ActiveAdmin.register LeaseApplication, namespace: :dealers do
  include LeaseApplicationExport
  before_action :deal_expire, only: %i[swap_lessee remove_colessee bike_change submit_application edit update add_colessee add_attachments request_lease_documents]
  before_action :disallow_bike_change, only: [:bike_change]
  before_action :disallow_coapplicant_removal, only: [:remove_colessee]
  before_action :disallow_swap_lessee, only: [:swap_lessee]
  before_action :disallow_add_colessee, only: [:add_colessee]
  before_action :disallow_request_lease_documents, only: [:request_lease_documents]
  before_action :load_application_settings
  menu html_options: { class: 'menu-button' }

  actions :all, except: [:destroy]

  config.action_items.delete_if { |item| item.display_on?(:show) }
  config.sort_order = 'updated_at_desc'

  scope_to do
    current_dealer.dealership
  end

  decorate_with LeaseApplicationDecorator

  action_item(:payment_calculator, only: :index) do
    link_to 'New Payment Calculator', %i[new dealers lease_calculator]
  end

  action_item(:payment_calculator, only: %i[show edit]) do
    if resource.lease_calculator && (resource.credit_status.eql?('unsubmitted') || resource.credit_status.eql?('Saved - NOT Submitted'))
      link_to 'Edit Payment Calculator', edit_dealers_lease_calculator_path(resource.lease_calculator.id)
    end
  end

  action_item(:payment_calculator_view, only: %i[show edit]) do
    if resource.lease_calculator
      link_to 'View Payment Calculator', dealers_lease_calculator_path(resource.lease_calculator.id)
    end
  end

  member_action(:swap_lessee, method: :put) do
    message = Dealers::LeaseApplicationFacade.new(lease_application: resource).swap_lessee!
    redirect_to dealers_root_path, message
  end

  member_action(:add_colessee, method: %i[get patch]) do
    if request.patch?
      raise 'Unauthorized' unless resource.can_add_coapplicant?

      if resource.update(colessee_params)
        if resource.approved_with_contingencies? || resource.approved?
          if resource.colessee_id.present?
            RunBlackboxService.new(
              lessee_id: resource.colessee_id,
              fetch_type: :fill,
              blackbox_job_opts: { request_control: :manual_pull, request_event_source: 'legacy/dealer/add-colessee' }
            ).run_lessee
          end
          resource.reset_after_adding_colessee!
        end
        DetectRelatedApplicationsJob.perform_async(resource.id)
        message = { notice: 'Co-applicant added' }
        DealerMailer.dealer_added_colessee(application: resource.object).deliver_later(wait: 1.minute)
        Notification.create_for_admins(
          notification_mode: 'InApp',
          notification_content: 'colessee_added',
          notifiable: resource
        )
        redirect_to dealers_root_path, message
      else
        message = { alert: 'Could not add Co-applicant' }
        render 'dealers/colessee/new', message
      end
    else
      @lease_application = Dealers::LeaseApplicationFacade.new(lease_application: resource).load_app
      gon.lessee_home_address = begin
                                  @lease_application.lessee.home_address
                                rescue StandardError
                                  {}
                                end
      render 'dealers/colessee/new'
    end
  end

  member_action(:add_attachments, method: %i[get post]) do
    if request.post?
      attachment = resource.lease_application_attachments.new(attachments_params)
      attachment.uploader = current_dealer
      if attachment.save
        DealerMailer.file_attachment_notification(attachment_id: attachment.id).deliver_later(wait: 1.minute)
        Notification.create_for_admins(
          notification_mode: 'InApp',
          notification_content: 'lease_attachment_added',
          notifiable: resource
        )
        message = { notice: 'Attachment added' }
      else
        message = { alert: "Could not add attachment.  #{attachment.errors.full_messages.to_sentence}" }
      end
      redirect_to add_attachments_dealers_lease_application_path(resource), message
    else
      @attachments                   = resource.lease_application_attachments
      @lease_application_attachments = LeaseApplicationAttachment.new
      render 'add_attachments'
    end
  end

  member_action(:lease_bank_information, method: %i[get patch]) do
    if request.patch?
      bank_information = resource.update(bank_information_params)
      if bank_information
        message = { notice: 'Bank Information Submitted.' }
        PrenoteJob.perform_async(resource.id)
      else
        message = { alert: "Could not submit Bank Information.  #{bank_information.errors.full_messages.to_sentence}" }
      end
      redirect_to dealers_root_path, message
    else
      @lease_application = Dealers::LeaseApplicationFacade.new(lease_application: resource).load_app
      render 'dealers/lease_applications/lease_bank_information'
    end
  end

  member_action(:request_lease_documents, method: %i[get post]) do
    if request.post?
      document_request = resource.lease_document_requests.new(lease_documents_params.except(:lease_application))
      if document_request.save
        resource.update(lease_documents_params[:lease_application])
        resource.update(document_status: 'documents_requested')
        VinValidation.create(validatable: document_request, lease_application: resource).verify
        Notification.create_for_admins(
          notification_mode: 'InApp',
          notification_content: 'lease_documents_requested',
          notifiable: resource,
          data: {
            lease_document_request_id: document_request.id
          }
        )
        Notification.create_for_support(
          notification_mode: 'Email',
          notification_content: 'lease_documents_requested',
          notifiable: resource,
          data: {
            lease_document_request_id: document_request.id
          }
        )

        message = { notice: 'Lease Documents Have Been Requested' }
        payment = lease_documents_params[:lease_application]
        if !payment[:payment_bank_name].blank? &&
           !payment[:payment_aba_routing_number].blank? &&
           !payment[:payment_account_number].blank? &&
           !payment[:payment_account_type].blank? &&
           !payment[:payment_account_holder].blank?
          NegativePayJob.perform_async(resource.lessee.id)
          PrenoteJob.perform_async(resource.id)
        end
        redirect_to dealers_root_path, message
      else
        message                  = { alert: 'Could not Request Lease Documents' }
        @request_lease_documents = document_request
        render 'dealers/lease_applications/request_lease_documents'
      end
    else
      @request_lease_documents = LeaseDocumentRequest.new
      render 'dealers/lease_applications/request_lease_documents'
    end
  end

  member_action(:bike_change, method: %i[get patch]) do
    if request.patch?
      Dealers::LeaseApplicationFacade.new(lease_application: resource.lease_application).bike_change!(bike_change_params)
      message = if resource.lease_calculator.update(bike_change_params)
                  { notice: 'Lease Calculator was successfully updated.' }
                else
                  { alert: 'There were problems updating this Lease Calculator.' }
                end
      redirect_to dealers_root_path, message
    else
      @lease_calculator            = resource.lease_calculator
      @bike_change                 = true
      gon.sum_of_payments_states   = UsState.sum_of_payments_states
      gon.dealership_default_state = States.name_from(abbreviation: current_dealer.dealership.state)

      ga = UsState.where(name: 'georgia')[0]
      @label_text = ga.tax_jurisdiction_type.name
      @hyperlink = nil
      @is_ga_custom = false
      if ga.tax_jurisdiction_type.name == 'Custom'
        @is_ga_custom = true
        @label_text   = 'GA TAVT Value'
        @hyperlink    = 'https://onlinemvd.dor.ga.gov/tap/Option1.aspx#message'
        unless ga.hyperlink.nil?
          @hyperlink  = ga.hyperlink
          @label_text = ga.label_text
        end
      end

      render 'dealers/lease_applications/bike_change'
    end
  end

  member_action(:remove_colessee, method: :put) do
    message =
      if ColesseeRemover.new(resource).remove_colessee!
        DetectRelatedApplicationsJob.perform_async(resource.id)
        { notice: 'Co-applicant removed' }
      else
        { alert: 'Could not remove Co-applicant' }
      end
    redirect_to dealers_root_path, message
  end

  member_action(:rescind_application, method: :put) do
    message = Dealers::LeaseApplicationFacade.new(lease_application: resource.object).rescind_application!
    redirect_to dealers_root_path, message
  end

  member_action(:submit_application, method: :put) do
    message = Dealers::LeaseApplicationFacade.new(lease_application: resource.object, dealer_check: true).submit_application!(event_source: 'legacy/dealer/submit')
    redirect_to dealers_root_path, message
  end

  # Application Identifier | Lessee | Co-Lessee | Motorcycle |
  # Credit Tier | Credit Status |Document Status |
  # Days Submitted | Updated At | Actions
  index do
    column :application_identifier do |resource|
      link_to resource.decorate.application_identifier, [:dealers, resource]
    end
    column 'Applicant name' do |resource|
      resource.lessee.decorate.display_name unless resource.lessee.blank?
    end
    column 'Co-Applicant name' do |resource|
      resource.colessee.decorate.display_name unless resource.colessee.blank?
    end
    column 'Model and Year' do |resource|
      resource.model_and_year
    end
    column :credit_tier
    column :credit_status
    column :document_status
    column :days_submitted
    column :updated_at
    column 'Actions' do |resource|
      div class: (resource&.dealership&.can_submit ? 'dropdown' : '') do
        button 'Actions <span class="caret"></span>'.html_safe, disabled: (resource&.dealership&.can_submit ? false : true), type: 'button', class: 'btn btn-default dropdown-toggle', 'data-toggle' => 'dropdown'
        ul class: 'dropdown-menu' do
          if resource.can_open_payment_calculator?
            li do
              link_to 'Open Payment Calculator', [:edit, :dealers, resource.load_or_create_lease_calculator]
            end
          elsif resource.can_change_bikes?
            li do
              link_to 'Open Payment Calculator', bike_change_dealers_lease_application_path(resource)
            end
          else
            li do
              link_to 'View Payment Calculator', [:dealers, resource.load_or_create_lease_calculator]
            end
          end

          if resource.can_open_credit_application?
            li do
              link_to 'Open Credit Application', [:edit, :dealers, resource]
            end
          else
            li do
              link_to 'View Credit Application', [:dealers, resource]
            end
          end
          unless resource.submitted?
            li do
              link_to 'Submit to Speed Leasing', submit_application_dealers_lease_application_path(resource), method: :put, class: 'click-limit'
            end
          end
          if resource.can_swap_applicants?
            li do
              link_to 'Swap Applicants', swap_lessee_dealers_lease_application_path(resource), method: :put
            end
          end
          if resource.can_add_coapplicant?
            li do
              link_to 'Add Co-applicant', add_colessee_dealers_lease_application_path(resource)
            end
          end
          li do
            link_to 'View / Add References', new_dealers_lease_application_reference_path(resource)
          end
          unless resource.expired?
            li do
              link_to 'Add Attachment', add_attachments_dealers_lease_application_path(resource)
            end
          end
          if resource.can_change_bikes?
            li do
              link_to 'Bike Change', bike_change_dealers_lease_application_path(resource)
            end
            li do
              link_to 'Change Tax Jurisdiction', bike_change_dealers_lease_application_path(resource)
            end
            li do
              link_to 'Change Mileage', bike_change_dealers_lease_application_path(resource)
            end
          end
          if resource.can_request_lease_documents?
            li do
              link_to 'Request Lease Documents', request_lease_documents_dealers_lease_application_path(resource)
            end
          end
          if resource.can_remove_coapplicant?
            li do
              link_to 'Remove Co-applicant', remove_colessee_dealers_lease_application_path(resource),
                      method: :put, data: { confirm: 'ARE YOU SURE?  This action CAN NOT BE UNDONE and will remove this Co-applicant from the application PERMANENTLY.' }
            end
          end

          selected_status = LeaseApplication.aasm(:document_status).states.map(&:name).select { |s| %i[documents_requested documents_issued lease_package_received funding_delay funding_approved funded].include?(s) }
          if selected_status.include?(resource.document_status.parameterize.underscore.to_sym)
            li do
              link_to 'Submit Bank Information', lease_bank_information_dealers_lease_application_path(resource)
            end
          end
        end
      end
    end
  end

  # filter :lessee_first_name_or_lessee_last_name_or_colessee_first_name_or_colessee_last_name_cont, label: 'Name Contains'
  filter :by_lessee_name, as: :string, label: 'Name'
  filter :credit_status, as: :select, collection: LeaseApplication.aasm(:credit_status).states_for_select
  filter :document_status, as: :select, collection: LeaseApplication.aasm(:document_status).states_for_select
  filter :can_change_bikes, as: :select, label: 'Can Change Bikes?', collection: [['Yes', true], ['No', false]]

  form partial: 'form'

  controller do
    before_action :disallow_after_submission, only: %i[edit update]
    def permitted_params
      params.permit!
    end

    def scoped_collection
      super.includes(%i[lessee colessee lease_calculator]).limit(1000)
    end

    def new
      @lease_application = Dealers::LeaseApplicationFacade.new.build_app
    end

    def edit
      @lease_application = Dealers::LeaseApplicationFacade.new(lease_application: resource).load_app
    end

    def update
      update! do |success, _failure|
        success.html do
          resource.touch
          if ActiveRecord::Type::Boolean.new.cast(params[:save_submit])
            message = Dealers::LeaseApplicationFacade.new(lease_application: resource, dealer_check: true).submit_application!(event_source: 'legacy/dealer/update-save-submit')
            redirect_to dealers_root_path, message
          else
            redirect_to edit_dealers_lease_application_path(resource)
          end
        end
      end
    end

    def create
      # set dealer_id param
      params[:lease_application].merge!(dealer_id: current_dealer.id, submitting_ip_address: current_dealer.current_sign_in_ip)
      create! do |success, _failure|
        success.html do
          resource.load_or_create_lease_calculator
          update_tax_rates
          if ActiveRecord::Type::Boolean.new.cast(params[:save_submit])
            message = Dealers::LeaseApplicationFacade.new(lease_application: resource, dealer_check: true).submit_application!(event_source: 'legacy/dealer/create-save-submit')
            redirect_to dealers_root_path, message
          else
            redirect_to edit_dealers_lease_application_path(resource)
          end
        end
      end
    end

    def show
      @lease_application = Dealers::LeaseApplicationFacade.new(lease_application: resource).load_app
      @page_title        = @lease_application.display_name
      render layout: 'active_admin'
    end

    private

    def load_application_settings
      @setting = CommonApplicationSetting.first
    end

    def deal_expire
      redirect_to dealers_root_path, alert: 'This Lease Application has Expired' and return if resource.expired?
    end

    def colessee_params
      params.require(:lease_application).permit!
    end

    def attachments_params
      params.require(:lease_application_attachment).permit(:id, :upload, :notes, :_destroy)
    end

    def lease_documents_params
      params.require(:lease_document_request).permit!
    end

    def bike_change_params
      params.require(:lease_calculator).permit!
    end

    def bank_information_params
      params.require(:lease_application).permit!
    end

    def update_tax_rates
      state = UsState.find_by_abbreviation(params[:lease_application][:lessee_attributes][:home_address_attributes][:state])
      dealer_state = @current_dealer.dealership.address.state
      if state&.tax_jurisdiction_type&.name&.include?('Customer') || (state&.tax_jurisdiction_type&.name&.include?('Dealer') && (dealer_state != state&.abbreviation))
        city_name = params[:lease_application][:lessee_attributes][:home_address_attributes][:city]
        zipcode = params[:lease_application][:lessee_attributes][:home_address_attributes][:zipcode]
        county_name = params[:lease_application][:lessee_attributes][:home_address_attributes][:county]
        county = County.where(us_state_id: state&.id, name: county_name).first
      else
        city_name = @current_dealer.dealership.address.city
        zipcode = @current_dealer.dealership.address.zipcode
        county_name = @current_dealer.dealership.address.county
        county = County.where(us_state_id: state&.id, name: county_name).first
      end
      city = City.where(county_id: county&.id, name: city_name, us_state_id: state&.id).where("'#{zipcode}' between city_zip_begin and city_zip_end").first
      @lease_application.city_id = city&.id
      @lease_application.save
    end

    def disallow_after_submission
      if resource.submitted?
        redirect_to dealers_lease_applications_path, alert: 'This action cannot be completed after application has been submitted.' and return
      end
    end

    def redirect_for_restriction
      redirect_to dealers_lease_applications_path, alert: 'This action cannot be completed after application has been submitted.' and return
    end

    def disallow_bike_change
      redirect_for_restriction unless resource.can_change_bikes?
    end

    def disallow_coapplicant_removal
      redirect_for_restriction unless resource.can_remove_coapplicant?
    end

    def disallow_swap_lessee
      redirect_for_restriction unless resource.can_swap_applicants?
    end

    def disallow_add_colessee
      redirect_for_restriction unless resource.can_add_coapplicant?
    end

    def disallow_request_lease_documents
      redirect_for_restriction unless resource.can_request_lease_documents?
    end
  end
end

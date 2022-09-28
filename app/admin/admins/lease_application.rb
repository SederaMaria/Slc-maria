ActiveAdmin.register LeaseApplication, namespace: :admins do
  menu priority: 1

  actions :all, except: [:new, :create, :destroy]

  decorate_with LeaseApplicationDecorator

  config.clear_action_items!

  action_item :index do
    link_to 'Export to CSV', csv_export_admins_lease_applications_path(q: params[:q]&.permit!), method: :post, data: { confirm: "This will send a CSV export of Lease Applications to email:\n\n#{current_admin_user.email}\n\nAre you sure?" }
  end

  action_item :index do
    link_to 'Export Access DB', access_db_export_admins_lease_applications_path(q: params[:q]&.permit!), method: :post, data: { confirm: "This will send an Access DB Export to email:\n\n#{current_admin_user.email}\n\nAre you sure?" }
  end

  action_item :index do
    link_to 'Export Funding Delays', funding_delay_export_admins_lease_applications_path(q: params[:q]&.permit!), method: :post, data: { confirm: "This will send an Access DB Export to email:\n\n#{current_admin_user.email}\n\nAre you sure?" }
  end

  collection_action :csv_export, method: :post do
    ExportLeaseApplicationsJob.perform_async(email: current_admin_user.email, filter: params[:q]&.permit!&.to_h)
    redirect_to(admins_lease_applications_path(q: params[:q]&.permit!), { notice: "A CSV export will shortly be sent to #{current_admin_user.email}." })
  end

  collection_action :access_db_export, method: :post do
    ExportAccessDbJob.perform_async(email: current_admin_user.email, filter: params[:q]&.permit!&.to_h)
    redirect_to(admins_lease_applications_path(q: params[:q]&.permit!), { notice: "An Access DB Export will shortly be sent to #{current_admin_user.email}." })
  end

  collection_action :funding_delay_export, method: :post do
    ExportFundingDelayJob.perform_async(email: current_admin_user.email)
    redirect_to(admins_lease_applications_path(q: params[:q]&.permit!), { notice: "A Funding Delay Export will shortly be sent to #{current_admin_user.email}." })
  end

  action_item(:application_expired, only: :show) {
    resource.expired_warning if resource.expired?
  }

  action_item(:override_calculator, only: :show) {
    link_to 'Override Calculator', override_admins_lease_calculator_path(resource.lease_calculator)
  }

  action_item(:edit_application, only: :show) {
    link_to 'Edit Lease Application', edit_admins_lease_application_path(resource)
  }

  action_item(:submit_application, only: :show) {
    link_to 'Submit Application', submit_application_admins_lease_application_path(resource), method: :put, data: { confirm: "This will submit the current Lease Application.\n\nAre you sure?" } unless resource.submitted?
  }

  action_item(:payment_calculator, only: :show) {
    #there is no "first_or_create"
    link_to 'Payment Calculator', [:edit, :admins, resource.load_or_create_lease_calculator]
  }

  action_item(:resend_credit_decision, only: :show) {
    unless resource.notifications.credit_decision_emails.blank?
      link_to 'Re-send Credit Decision', resend_credit_decision_admins_lease_application_path(resource), method: :put, data: { confirm: "This will resend Credit Decision emails to all of the dealerships dealers.\n\nAre you sure?" }
    end
  }

  action_item(:generate_credit_decision_notifications, only: :show) {
    if resource.can_send_credit_decision?
      link_to 'Generate Credit Decision Emails', generate_credit_decision_notifications_admins_lease_application_path(resource),
              method: :put, data: { confirm: "This will generate credit decision notification emails for the dealership AND send them.\n\nAre you sure?" }
    end
  }

  action_item(:swap_lessee, only: :show) do
    link_to 'Swap Applicants', swap_lessee_admins_lease_application_path(resource), method: :put
  end

  action_item(:verification, only: [:show, :add_funding_delays]) do
    link_to 'Lease Verification', [:verification, :admins, resource]
  end

  action_item(:edit_credit_tier, only: [:show]) do
    link_to 'Edit Credit Tier', [:edit_credit_tier, :admins, resource]
  end

  action_item(:funding_approval_checklist, only: :show) do
    link_to 'Generate Funding Approval Checklist', funding_approval_checklist_admins_lease_application_path(resource), method: :put
  end

  action_item(:online_funding_approval_checklist, only: [:show]) do
    link_to 'Online Funding Approval Checklist', "#{ENV['LOS_UI_URL']}/online-funding-approval-checklist/#{resource.id}"
  end


  member_action(:submit_application, method: :put) do
    message = Dealers::LeaseApplicationFacade.new(lease_application: resource.object, dealer_check: false).submit_application!(event_source: 'legacy/admin/submit-override')
    redirect_to admins_root_path, message
  end

  member_action(:funding_approval_checklist, method: :put) do
    file = FundingApprovalChecklist.generate(application: resource)
    send_file file
  end

  member_action(:power_of_attorney_applicant, method: :put) do
    err = "Please complete the required fields"
    lease_documents_request = resource.last_lease_document_request
    err += ", Asset Year" if lease_documents_request&.asset_year.nil?
    err += ", Asset Make" if lease_documents_request&.asset_make.nil?
    err += ", Asset Model" if lease_documents_request&.asset_model.nil?
    err += ", Asset VIN" if lease_documents_request&.asset_vin.nil?
    err += ", Delivery Date" if lease_documents_request&.delivery_date.nil?

    if err != "Please complete the required fields"
      redirect_to resource_path, flash: {warning: "#{err}"}
    else
      send_file PowerOfAttorneyDocument.new(resource, resource.lessee).generate
    end
  end

  action_item(:power_of_attorney_applicant, only: [:show, :verification]) do
    link_to 'POA (APPLICANT)', power_of_attorney_applicant_admins_lease_application_path(resource), method: :put
  end

  member_action(:power_of_attorney_coapplicant, method: :put) do
    send_file PowerOfAttorneyDocument.new(resource, resource.colessee).generate
  end

  action_item(:power_of_attorney_coapplicant, only: [:show, :verification]) do
    if resource.colessee.present?
      link_to 'POA (CO-APPLICANT)', power_of_attorney_coapplicant_admins_lease_application_path(resource), method: :put
    end
  end

  member_action(:generate_credit_decision_notifications, method: :put) do
    Notification.create_for_dealership({
                                         notification_mode:    'Email',
                                         notification_content: 'credit_decision',
                                         notifiable:           resource
                                       }, dealership: resource.dealership)
    redirect_to resource_path, { notice: 'Credit decision notification emails will now be sent to the dealership.' }
  end

  member_action(:resend_credit_decision, method: :put) do
    resource.notifications.credit_decision_emails.map(&:resend)
    message = { notice: 'Credit decision notification emails will now be resent.' }
    redirect_to resource_path, message
  end

  member_action(:create_lease_application_welcome_call, method: [:post]) do
    message = { flash: { warning: 'Invalid First Payment Date'} }
    if resource&.first_payment_date.nil?
      redirect_to verification_admins_lease_application_path(resource), message
    else
      # is_valid_due_date = ((resource&.first_payment_date.to_date - welcome_call_params['due_date'].to_date).to_i >= 15)
      # message = { flash: { warning: 'Welcome Call Due Date should be 15 days before the First Payment Date.'} } if !is_valid_due_date
      # unless !is_valid_due_date
        message = { notice: 'Welcome Call Created' }
        welcome_call = resource.lease_application_welcome_calls.create(welcome_call_params.merge!({ welcome_call_representative_type_id: 1, admin_id: current_admin_user.id }))
      # end
      unless params[:lease_application_welcome_call][:department] == resource.department_id
        resource.update(department: Department.find(params[:lease_application_welcome_call][:department]))
      end

      unless params[:lease_application_welcome_call][:lease_application_due_date].to_date == resource.welcome_call_due_date
        resource.update(welcome_call_due_date: params[:lease_application_welcome_call][:lease_application_due_date].to_date)
      end
      redirect_to verification_admins_lease_application_path(resource), message
    end


  end


  member_action(:edit_credit_tier, method: [:get, :post]) do
    if request.post?
      lease_calculator = resource.lease_calculator
      lease_calculator.notes = params['lease_calculator']['notes']
      lease_calculator.credit_tier_id = params['lease_calculator']['credit_tier_id']
      ct = lease_calculator.credit_tier_v2.description.split(' ')[1]&.to_i
      lease_calculator.dealer_participation_markup = 0.0 if ct > 5
      if lease_calculator.save
        RecalculateLeaseCalculatorsJob.perform_later(lease_calculator_id: lease_calculator.id)
        message = { notice: 'Application Updated' }
        redirect_to "#{ENV['LOS_UI_URL']}/lease-applications/#{resource.id}"
      else
        message = { alert: "Could update application.  #{lease_calculator.errors.full_messages.to_sentence}" }
        redirect_to edit_credit_tier_admins_leases_application(resource), message
      end
    else
      @lease_application = Dealers::LeaseApplicationFacade.new(lease_application: resource).load_app
      @lease_calculator = resource.lease_calculator
      @datax = @lease_application.lease_application_blackbox_requests
      @lessee = @lease_application.lessee
      @colessee = @lease_application.colessee
      @calculator = @lease_application.lease_calculator
      @insurance = @lease_application.insurance
      @last_document_request = @lease_application.last_lease_document_request
      make = Make.find_by(name: @lease_calculator.asset_make)
      # @credit_tiers = CreditTier.where(make_id: make&.id, model_group_id: @lease_calculator&.credit_tier_v2&.model_group_id).order(:position).pluck(:description)
      @credit_tiers = CreditTier.where(make_id: make&.id, model_group_id: @lease_calculator.model_group_record&.id).order(:position).pluck(:description, :id)
      unless resource&.lessee&.credit_reports&.order(created_at: :desc)&.first&.recommended_credit_tier.nil?
        @tier_level = resource.lessee.credit_reports.order(created_at: :desc).first.recommended_credit_tier.credit_tier&.tier_level
      end
      @page_title = "Credit Tier For Lease Application #{@lease_application.application_identifier}"
    end
  end

  member_action(:verification, method: [:get, :post]) do
    if request.post?
      if resource.update!(lease_verification_params)
        insurance = resource.insurance
        insurance.set_insurance_company_id
        message = { notice: 'Application Updated' }
        redirect_to resource_path, message
      else
        message = { alert: "Could update application.  #{application.errors.full_messages.to_sentence}" }
        redirect_to verification_admins_lease_application(resource), message
      end
    else
      @lease_application = Dealers::LeaseApplicationFacade.new(lease_application: resource).load_app
      @lessee = @lease_application.lessee
      @colessee = @lease_application.colessee
      @calculator = @lease_application.lease_calculator
      @insurance = @lease_application.insurance
      @last_document_request = @lease_application.last_lease_document_request
      @page_title = "Verification For #{@lease_application.application_identifier}"
      @welcome_calls = @lease_application.lease_application_welcome_calls
      welcome_call_status_id = @welcome_calls&.last&.welcome_call_status_id == 1 ? 1 : 2
      @welcome_call = LeaseApplicationWelcomeCall.new(welcome_call_status_id: welcome_call_status_id, welcome_call_type_id: 1, lease_application_due_date: (@lease_application&.welcome_call_due_date.nil? ? @lease_application&.calculate_welcome_call_due_date&.strftime('%m/%d/%Y') : @lease_application&.welcome_call_due_date&.strftime('%m/%d/%Y')) )
      if @lease_application.payment_frequency == "split"
        @total_monthly_payment = (@calculator&.total_monthly_payment * 0.5).round(2)
        @monthly_payment_label = 'Twice per Month'
      elsif @lease_application.payment_frequency == "full"
        @monthly_payment_label = 'Monthly'
        @total_monthly_payment = @calculator&.total_monthly_payment
      end
      @prenotes_status = @lease_application.get_prenote_status
    end
  end

  action_item(:welcome_call, only: :show) {
    link_to 'view', '#'
  }

  member_action(:swap_lessee, method: :put) do
    message =
      if LesseeAndColesseeSwapper.new(lease_application: resource).swap!
        { notice: 'Swap successfull' }
      else
        { alert: 'Could not perform swap, because colessee is not added' }
      end
    redirect_to resource_path, message
  end

  # member_action(:submit_application, method: :put) do
  #   message = Dealers::LeaseApplicationFacade.new(lease_application: resource.object).submit_application!
  #   redirect_to resource_path, message
  # end

  action_item(:remove_colessee, only: :show) do
    if resource.colessee.present?
      link_to 'Remove Colessee', remove_colessee_admins_lease_application_path(resource),
              method: :put, data: { confirm: "Removing the Co-Applicant will send this application back to Awaiting Credit Decision and will DESTROY the Colessee PERMANENTLY.\n\nAre you sure you want to continue?" }
    end
  end

  action_item(:unexpire_application, only: :show) do
    if resource.expired?
      link_to("Un-Expire Application",
              [:unexpire_lease_application, :admins, resource],
              method: :patch)
    end
  end

  member_action(:unexpire_lease_application, method: :patch) do
    message =
      if resource.update(expired: false)
        { notice: 'Lease application unexpired' }
      else
        { alert: 'Could not unexpire lease application ' }
      end
    redirect_back(fallback_location: admins_root_path, **message)
  end

  action_item(:expire_application, only: :show) do
    unless resource.expired?
      link_to("Force Expire Application",
              [:expire_lease_application, :admins, resource],
              method: :patch)
    end
  end

  member_action(:expire_lease_application, method: :patch) do
    message =
      if resource.update(expired: true)
        { notice: 'Lease application has been force expired' }
      else
        { alert: 'Could not expire this lease application ' }
      end
    redirect_back(fallback_location: admins_root_path, **message)
  end

  member_action(:remove_colessee, method: :put) do
    message =
      if ColesseeRemover.new(resource).remove_colessee!
        { notice: 'Colessee removed' }
      else
        { alert: 'Could not remove colessee' }
      end
    redirect_to resource_path, message
  end

  member_action(:add_attachments, method: [:get, :post]) do
    if request.post?
      attachment = resource.lease_application_attachments.new(attachments_params)
      attachment.uploader = current_admin_user
      if attachment.save
        message = { notice: 'Attachment added' }
      else
        message = { alert: "Could not add attachment.  #{attachment.errors.full_messages.to_sentence}" }
      end
      redirect_to add_attachments_admins_lease_application_path(resource), message
    else
      @attachments                   = resource.lease_application_attachments
      @lease_application_attachments = LeaseApplicationAttachment.new(visible_to_dealers: false)
      render 'add_attachments'
    end
  end

  action_item(:add_attachments, only: :show) do
    link_to 'Add Attachment', add_attachments_admins_lease_application_path(resource)
  end

  member_action(:add_stipulations, method: [:get, :post]) do
    if request.post?
      attachment = resource.lease_application_stipulations.new(stipulations_params)
      if attachment.save
        message = { notice: 'Created Lease Application Stipulation' }
      else
        message = { alert: "Could not add Stipulation.  #{attachment.errors.full_messages.to_sentence}" }
      end
      redirect_to add_stipulations_admins_lease_application_path(resource), message
    else
      @lease_application              = resource
      @stipulations                   = Admins::LeaseApplicationStipulationDecorator.wrap(resource.lease_application_stipulations)
      @lease_application_stipulations = LeaseApplicationStipulation.new()
      @page_title                     = "Add Stipulations #{LeaseApplicationDecorator.new(@lease_application).stipulation_identifier}"
      render 'add_stipulations'
    end
  end

  action_item(:manage_stipulations, only: :show) do
    link_to 'Manage Stipulations', add_stipulations_admins_lease_application_path(resource)
  end

  member_action(:add_funding_delays, method: [:get, :post]) do
    if request.post?
      attachment = resource.funding_delays.new(funding_delay_params)
      if attachment.save
        message = { notice: 'Saved New Funding Delay' }
      else
        message = { alert: "Could not add Funding Delay.  #{attachment.errors.full_messages.to_sentence}" }
      end
      redirect_to add_funding_delays_admins_lease_application_path(resource), message
    else
      @lease_application  = resource
      @funding_delays     = FundingDelay.new
      @page_title         = "Add Funding Delays #{LeaseApplicationDecorator.new(@lease_application).stipulation_identifier}"
      render 'add_funding_delays'
    end
  end

  action_item(:manage_funding_delays, only: [:show, :verification]) do
    link_to 'Manage Funding Delays', add_funding_delays_admins_lease_application_path(resource)
  end

  action_item(:rerun_credit_reports, only: :show) do
    if resource.expired
      link_to(
        "Re-Pull Credit Reports",
        [:rerun_credit_reports, :admins, resource],
        data: { confirm: "THIS ACTION WILL PULL AN BOTH APPLICANT'S LIVE CREDIT PROFILE(S).\n\nARE YOU SURE?" }
      )
    end
  end

  member_action(:rerun_credit_reports) do
    RunBlackboxService.new(lessee_id: resource.lessee.id, fetch_type: :fill, request_type: :repull, blackbox_job_opts: { request_control: :manual_pull, request_event_source: 'legacy/admin/rerun-credit-reports' }).run_lessee_colessee
    redirect_to resource_path, notice: 'Credit Reports Will Be Repulled and Appear as a File Attachment Shortly'
  end

  action_item(:rerun_lessee_credit_report, only: :show) do
    if resource.expired
      link_to(
        "Re-Pull Lessee Credit",
        [:rerun_lessee_credit_report, :admins, resource],
        data: { confirm: "THIS ACTION WILL PULL THE LESSEE'S LIVE CREDIT PROFILE.\n\nARE YOU SURE?" }
      )
    end
  end

  member_action(:rerun_lessee_credit_report) do
    RunBlackboxService.new(lessee_id: resource.lessee.id, fetch_type: :fill, request_type: :repull, blackbox_job_opts: { request_control: :manual_pull, request_event_source: 'legacy/admin/rerun-lessee-credit-report' }).run_lessee
    redirect_to resource_path, notice: 'Credit Reports Will Be Repulled and Appear as a File Attachment Shortly'
  end

  action_item(:rerun_colessee_credit_report, only: :show) do
    if resource.expired
      link_to(
        "Re-Pull Co-Lessee Credit",
        [:rerun_colessee_credit_report, :admins, resource],
        data: { confirm: "THIS ACTION WILL PULL THE CO-LESSEE'S LIVE CREDIT PROFILE.\n\nARE YOU SURE?" }
      )
    end
  end

  member_action(:rerun_colessee_credit_report) do
    RunBlackboxService.new(lessee_id: resource.colessee.id, fetch_type: :fill, request_type: :repull, blackbox_job_opts: { request_control: :manual_pull, request_event_source: 'legacy/admin/rerun-colessee-credit-report' }).run_lessee if resource.colessee_id.present?
    redirect_to resource_path, notice: 'Credit Reports Will Be Repulled and Appear as a File Attachment Shortly'
  end

  action_item(:rerun_datax, only: :show) do
    link_to(
      "Re-Send Blackbox",
      [:rerun_datax, :admins, resource],
      data: { confirm: "THIS ACTION WILL RE SEND THE Blackbox.\n\nARE YOU SURE?" }
    )
  end

  member_action(:rerun_datax) do
    RunBlackboxService.new(lessee_id: resource.lessee_id, fetch_type: :fill, blackbox_job_opts: { request_control: :manual_pull, request_event_source: 'legacy/admin/rerun-datax' }).run_lessee_colessee
    redirect_to resource_path, notice: 'Blackbox Will Be Repulled Shortly'
  end


  action_item(:request_lease_package, only: :show) do
    if resource.lease_document_requests.exists?
      link_to(
        "Request Lease Package",
        [:request_lease_package, :admins, resource],
        data: { confirm: "THIS ACTION WILL GENERATE A LEASE PACKAGE.\n\nARE YOU SURE?" }
      )
    end
  end

  member_action(:request_lease_package) do
    LeasePackageGeneratorJob.set(wait: 5.seconds).perform_later(application_id: resource.id)
    redirect_to resource_path, notice: 'Your Lease Package will be generated and will appear as a File Attachment Shortly'
  end


  action_item(:resend_funding_request, only: :show) do
    if resource.document_status == 'Funding Approved'
      link_to(
        "Resend Funding Request",
        [:resend_funding_request, :admins, resource]
      )
    end
  end

  member_action(:resend_funding_request) do
    resource.check_funding_request(override: true)
    redirect_to resource_path, notice: 'Your funding request has been submitted.'
  end

  member_action(:new_page) do
    redirect_to "#{ENV['LOS_UI_URL']}/lease-applications/#{resource.id}"
  end

  member_action(:request_new_prenote) do
    PrenoteJob.perform_async(resource.id)
    redirect_to resource_path, notice: 'Prenote successfully requested!'
  end

  member_action(:request_review) do
    workflow = WorkflowStatus.underwriting_review
    resource.update(workflow_status: workflow)
    resource.notify_underwriting
    redirect_to edit_admins_lease_application_path(resource), notice: 'Review successfully requested!'
  end

  member_action(:approved_underwriting) do
    workflow = WorkflowStatus.find_by(description: 'Underwriting Approved')
    resource.update(workflow_status: workflow)
    redirect_to edit_admins_lease_application_path(resource), notice: 'Review successfully approved!'
  end

  config.sort_order = 'updated_at_desc'

  index download_links: false do
    if params[:q].present?
      div class: 'dealership_filter' do
        limit = LeaseApplication.unscoped.count
        q = LeaseApplication.ransack(params[:q])
        q.result(distinct: true).limit(limit).pluck(:dealership_id).uniq.count.to_s + " unique dealerships"
      end
    end
    column :application_identifier do |resource|
      link_to resource.decorate.application_identifier, "#{ENV['LOS_UI_URL']}/lease-applications/#{resource.id}"
    end
    column 'Dealership' do |resource|
      link_to resource.dealership.name, "#{ENV['LOS_UI_URL']}/dealerships/#{resource.dealership.id}"
    end
    column :lessee
    column :colessee
    column 'Asset' do |resource|
      resource.model_and_year
    end
    column :credit_tier
    column :credit_status
    column :document_status
    column :updated_at
    column :expiration_date
    column 'Actions' do |resource|
      div class: 'dropdown' do
        button 'Actions <span class="caret"></span>'.html_safe, type: 'button', class: 'btn btn-default dropdown-toggle', 'data-toggle' => 'dropdown'
        ul class: 'dropdown-menu' do
          li do
            link_to 'View Credit Application', "#{ENV['LOS_UI_URL']}/lease-applications/#{resource.id}"
          end
          li do
            link_to 'Edit Credit Application', "#{ENV['LOS_UI_URL']}/lease-applications/#{resource.id}"
          end
          li do
            link_to 'Lease Verification', [:verification, :admins, resource]
          end
          li do
            link_to 'View / Add References', new_admins_lease_application_reference_path(resource)
          end
          li do
            link_to 'Edit Payment Calculator', [:edit, :admins, resource.load_or_create_lease_calculator]
          end
          li do
            link_to 'Submit to Speed Leasing (ADMIN OVERRIDE)', submit_application_admins_lease_application_path(resource), method: :put
          end unless resource.submitted?
        end
      end
    end
  end

  filter :application_identifier
  filter :dealership, as: :select, collection: proc { Dealership.order(:name).pluck(:name, :id) }
  filter :dealer, collection: proc { Dealer.includes(:dealership).limit(1000).order(:last_name).collect { |dealer| [dealer.display_name, dealer.id] } }, label: 'Dealer User'
  filter :by_dealer_representative, :as => :select, collection: proc { DealerRepresentative.joins("JOIN admin_users as au ON dealer_representatives.email = au.email WHERE au.is_active = true ORDER BY dealer_representatives.first_name, dealer_representatives.last_name").map{|dealer_rep| [dealer_rep.full_name, dealer_rep.id] } }, label: 'Dealer Representative'
  filter :dealership_state, as: :select, collection: States::ABBREVIATIONS
  filter :lessee_home_address_state, as: :select, collection: proc { Address.order(:state).pluck('DISTINCT state').compact }, label: 'Applicant State'
  filter :by_stipulation, as: :select, collection: proc { Stipulation.order(:description).collect { |stipulation| [stipulation.description, stipulation.id] } }, label: 'Stipulation'
  filter :lease_calculator_mileage_tier, as: :select, collection: proc { LeaseCalculator.order(:mileage_tier).pluck('DISTINCT mileage_tier').compact }, label: 'Mileage Tier'
  filter :lease_calculator_credit_tier, as: :select, collection: proc { LeaseCalculatorServices::CreditTiers.retrieve }, label: 'Credit Tier'
  filter :lease_calculator_asset_make, as: :select, collection: proc { Make.where(active: true).map(&:name) }, label: 'Make'
  filter :by_calculator_status, as: :select, label: 'New/Used?', collection: ["New", "Used"]
  filter :lease_document_requests_asset_vin_cont, label: 'Lease Document Request VIN'
  filter :by_lessee_name, as: :string, label: 'Name'
  filter :by_lessee_full_name, as: :string, label: 'Lessee'
  filter :by_lessee_first_name, as: :string, label: 'First Name (Lessee)'
  filter :by_lessee_last_name, as: :string, label: 'Last Name (Lessee)'
  filter :by_colessee_full_name, as: :string, label: 'Colessee'
  filter :by_colessee_first_name, as: :string, label: 'First Name (Co-Lessee)'
  filter :by_colessee_last_name, as: :string, label: 'Last Name (Co-Lessee)'
  filter :by_lessee_ssn, as: :string, label: 'Lessee Or Colessee SSN'
  filter :submitted_at, label: 'Application Date', as: :date_range
  filter :funding_delay_on, label: 'Funding Delay', as: :date_range
  filter :funding_approved_on, label: 'Funding Approved', as: :date_range
  filter :funded_on, label: 'Funded Date', as: :date_range
  filter :documents_issued_date, label: 'Documents Date', as: :date_range
  filter :lease_package_received_date, label: 'Documents Received Date', as: :date_range
  filter :document_status, as: :check_boxes, collection: LeaseApplication.aasm(:document_status).states_for_select.to_h
  filter :credit_status, as: :check_boxes, collection: LeaseApplication.aasm(:credit_status).states_for_select.to_h
  filter :has_application, as: :select, label: 'Has Application?', collection: [["Yes", true], ["No", false]]
  filter :has_calculator, as: :select, label: 'Has Calculator?', collection: [["Yes", true], ["No", false]]
  filter :has_coapplicant, as: :select, label: 'Has Co-Applicant?', collection: [["Yes", true], ["No", false]]
  filter :by_welcome_call_status, as: :select, collection: proc { WelcomeCallStatus.order(:id).collect { |status| [status.description, status.id] } }, label: 'Welcome Call Status'

  show do |lease_application|

    div class:'row testing-row' do
      link_to 'New Page', "#{ENV['LOS_UI_URL']}/lease-applications/#{resource.id}", class: 'button special'
    end

    active_admin_comments

    panel("Historical / Related Applications", class: "#{resource.connected_applications.exists? ? 'highlighted' : 'hidden'}") do
      table_for(resource.connected_applications.includes(:colessee).limit(1000)) do
        column 'Application' do |appl|
          link_to appl.application_identifier, admins_lease_application_path(appl)
        end
        column 'Credit Status' do |appl|
          appl.credit_status.titleize
        end
        column 'Document Status' do |appl|
          appl.document_status.titleize
        end
        column 'Lessee' do |appl|
          appl.lessee.name.upcase if appl.lessee_id.present?
        end
        column 'Colessee' do |appl|
          appl.colessee.name.upcase if appl.colessee_id.present?
        end
      end
    end

    if resource.lessee.present?
      unless resource.lessee.credit_reports.empty?
        unless resource.lessee.last_successful_credit_report&.recommended_credit_tier.nil?
          h3 :class => 'lessee_credit_score_text_red' do
            "Suggested credit tier: #{resource.lessee.last_successful_credit_report.recommended_credit_tier.credit_tier&.tier_level} (must meet all other underwriting guidelines)"
          end
        end
      end
    end

    attributes_table do
      row :application_identifier
      row :dealership
      row 'Dealer User' do |object|
        object.dealer
      end
      row :lessee do |object|
        link_to object.lessee.decorate.display_name.upcase, admins_lessee_path(object.lessee) unless object.lessee.blank?
      end
      row :colessee do |object|
        link_to object.colessee.decorate.display_name.upcase, admins_lessee_path(object.colessee) unless object.colessee.blank?
      end
      row :make
      row :model_and_year
      row :credit_tier
      row 'Lessee Average Credit Score' do
        resource.lessee.last_successful_credit_report&.credit_score_average rescue ''
      end
      row 'Colessee Average Credit Score' do
        resource.colessee.last_successful_credit_report&.credit_score_average rescue ''
      end
      row :credit_status
      row :document_status
      row :submitted_at
      row :days_submitted
      row 'Cumulative Haircut' do |app|
        app.lease_calculator.decorate.cumulative_haircut
      end
      row 'Documents Issued Date' do |object|
        object.documents_issued_date
      end
      row 'Documents Received Date' do |object|
        object.lease_package_received_date
      end
      row :funding_delay_on
      row :funding_approved_on
      row :funded_on
      row :promotion_name
      row :promotion_value
      row :expired
      row :created_at
      row :updated_at
      row 'Vehicle Possession' do |object|
        object&.vehicle_possession&.humanize
      end
    end

    panel("Lessee Banking Information") do
      table_for(lease_application) do
        column :payment_bank_name do |l|
          l.payment_bank_name
        end
        column :payment_aba_routing_number do |l|
          l.payment_aba_routing_number
        end
        column :payment_account_number do |l|
          l.payment_account_number
        end
        column :payment_account_type do |l|
          l.payment_account_type
        end
      end
    end

    panel("Co-Lessee Banking Information") do
      table_for(lease_application) do
        column :colessee_payment_bank_name do |l|
          l.colessee_payment_bank_name
        end
        column :colessee_payment_aba_routing_number do |l|
          l.colessee_payment_aba_routing_number
        end
        column :colessee_payment_account_number do |l|
          l.colessee_payment_account_number
        end
        column :colessee_payment_account_type do |l|
          l.colessee_payment_account_type
        end
      end
    end
    
    panel("Deleted Colessees") do
      table_for(lease_application.deleted_colessees) do
        column :full_name do |l|
          l.full_name
        end
        column :email_address do |l|
          l.email_address
        end
        column :deleted_at do |l|
          l.deleted_at
        end
      end
    end

    if lease_application.colessee
      panel("Relationship to Lessee") do
        table_for(lease_application.colessee) do
          column :full_name do |l|
            l.full_name
          end
          column :email_address do |l|
            l.email_address
          end
          column :lessee_and_colessee_relationship do |l|
            l.lessee_and_colessee_relationship
          end
        end
      end
    end

    panel("Lease Application Verifications") do
      table_for(lease_application.lease_validations.includes(:validatable).limit(1000)) do
        column :validatable do |lv|
          lv.display_label rescue ''
        end
        column 'Phone Number Line' do |lv|
          lv.phone_line if lv.is_phone_validation?
        end
        column 'Phone Number Carrier' do |lv|
          lv.phone_carrier if lv.is_phone_validation?
        end
        column :type do |lv|
          lv.type.titleize rescue ''
        end
        column :status do |lv|
          lv.status.titleize rescue ''
        end
      end
    end

   div do
      render partial: 'datax_employment_information_panel'
   end

   div do
      render partial: 'datax_panel'
   end

    div do
      panel("Lease Document Requests") do
        table_for(lease_application.lease_document_requests.order(created_at: :asc)) do
          column :asset_make
          column :asset_model
          column :asset_year
          column :asset_vin
          column "Color" do |ldr|
            ldr.asset_color
          end
          column "Vin Verified?" do |ldr|
            ldr.vin_validation&.status&.titleize
          end
          column "Actions" do |ldr|
            link_to 'View', [:admins, ldr]
          end
          column :created_at do |ldr|
            ldr.created_at.strftime('%B %-d %Y at %r %Z')
          end
        end
      end
    end
    div do
      render partial: 'funding_delay_panel'
    end
    div do
      panel("References") do
        table_for(lease_application.references.order(created_at: :desc)) do
          column :first_name
          column :last_name
          column :phone_number
          column :phone_number_line
          column :phone_number_carrier
          column :city
          column :state
        end
      end
    end

    div do
      panel("Stipulations") do
        table_for(Admins::LeaseApplicationStipulationDecorator.wrap(lease_application.lease_application_stipulations.includes(:stipulation).limit(1000))) do
          column :stipulation
          column :status
          column :notes
          column :attachment do |lease_application_stipulation|
            next unless lease_application_stipulation.attachment.present?
            link_to lease_application_stipulation.attachment_filename, lease_application_stipulation.attachment_url, target: '_blank'
          end
        end
      end
    end

    div do
       render partial: 'credit_report_panel'
    end

    div do
      panel("Attachments") do
        table_for(lease_application.lease_application_attachments.includes(:uploader).limit(1000).order(created_at: :desc)) do
          column "File Name" do |file|
            file.upload.file&.filename
          end
          column :created_at
          column 'Uploader' do |file|
            file&.uploader&.decorate&.display_name || 'Unknown / System'
          end
          column :description
          column :visible_to_dealers do |file|
            unless file.description == 'Funding Request Form'
              link_to (file.visible_to_dealers? ? 'YES' : 'NO'), toggle_visibility_admins_lease_application_attachment_path(file), method: :put, class: 'button'
            end
          end
          column "Download Link" do |file|
            link_to 'Download', file.upload.url, target: '_blank'
          end
          column "Send to Dealership" do |file|
            unless file.description == 'Funding Request Form'
              link_to 'Send', mail_attachment_to_dealership_path(file), method: :post, data: { confirm: "This will email the attachment to all dealers under the dealership.\n\nAre you sure you want to continue?" }
            end
          end
        end
      end
    end
    div do
      panel("Notification Emails") do
        attachments = NotificationAttachment.where(notification: lease_application.notifications.email).includes(notification: :recipient).limit(1000).order(created_at: :desc).distinct
        table_for(attachments) do
          column "Filename" do |file|
            file.upload.file&.filename rescue ''
          end
          column :recipient do |file|
            file.notification&.recipient&.email
          end
          column :description
          column "Download Link" do |file|
            file.upload.url.nil? ? '' : (link_to 'Download', file.upload.url, target: '_blank')
          end
          column "Resend" do |file|
            link_to 'Resend', resend_admins_notification_path(file.notification), method: :put
          end
          column "Originally Sent At" do |file|
            file.created_at
          end
          column "Last Sent At" do |file|
            file.updated_at
          end
        end
      end
    end
    div do
      panel("Audits") do
        table_for(Admins::AuditDecorator.wrap(lease_application.retrieve_audits)) do
          column :created_at
          column 'Lease Application', :audited
          column 'By Who', :user
          column 'Changes', :audited_changes
        end
      end
    end
  end

  form partial: 'form'

  controller do
    def scoped_collection
      super.includes(:dealer, :dealership, :lessee, :colessee, :lease_calculator).limit(1000)
    end

    def edit
      @lease_application = Dealers::LeaseApplicationFacade.new(lease_application: resource).load_app
    end

    def update
      document_status_param = params["lease_application"]["document_status"]
      if (['funding_approved', 'funded', 'lease_package_received'].include?(document_status_param)) && is_invalid_funding_params(document_status_param)
        selected_doc = params["lease_application"]["document_status"]
        message = { alert: "Please complete the required fields." }
        lease_verification_params.delete :document_status
        resource.update!(lease_verification_params)
        redirect_to verification_admins_lease_application_path(resource, selected_doc: selected_doc), message
      else
        update! do |success, failure|
          resource.touch
        end
      end
    end

    def permitted_params
      params.permit!
    end

    def welcome_call_params
      params.require(:lease_application_welcome_call).permit(:welcome_call_type_id, :welcome_call_result_id, :welcome_call_status_id, :due_date, :notes, :lease_application_welcome_call, :department)
    end

    def attachments_params
      params.require(:lease_application_attachment).permit(:id, :upload, :description, :notes, :_destroy, :visible_to_dealers)
    end

    def lease_verification_params
      if params.dig(:lease_application, :document_status)
        if resource.read_attribute_before_type_cast('document_status') != params[:lease_application][:document_status] && params[:lease_application][:document_status] == 'funding_approved'
          id = current_admin_user&.id
          return params.require(:lease_application).merge(approved_by: id, requested_by: id).permit!
        end
      end
      params.require(:lease_application).permit!
    end

    def stipulations_params
      params.require(:lease_application_stipulation).permit!
    end

    def funding_delay_params
      params.require(:funding_delay).permit!
    end

    def is_invalid_funding_params(doc_status)
      return true if resource&.insurance.nil?
      return true if funding_requirements_arr.push(resource&.funded_on).include?(nil) && doc_status == 'funded'
      return true if funding_requirements_arr.include?(nil) && doc_status == 'funding_approved'
      return true if payment_requirements_arr.include?(nil) && doc_status == 'lease_package_received'
      return false
    end

    def funding_requirements_arr
      [
        resource&.funding_approved_on,
        resource&.payment_bank_name,
        resource&.payment_account_type,
        resource&.payment_account_number,
        resource&.payment_frequency,
        resource&.payment_first_day,
        resource&.first_payment_date,
        resource&.payment_frequency,
        resource&.payment_account_holder,
        resource&.insurance&.company_name,
        resource&.insurance&.bodily_injury_per_person,
        resource&.insurance&.bodily_injury_per_occurrence,
        resource&.insurance&.comprehensive,
        resource&.insurance&.collision,
        resource&.insurance&.property_damage,
        resource&.insurance&.effective_date,
        resource&.insurance&.expiration_date,
        resource&.insurance&.policy_number
      ]
    end

    def payment_requirements_arr
      [
        resource&.payment_bank_name,
        resource&.payment_account_type,
        resource&.payment_account_number,
        resource&.payment_frequency,
        resource&.payment_first_day,
        resource&.first_payment_date,
        resource&.payment_frequency,
        resource&.payment_account_holder
      ]
    end


  end
end
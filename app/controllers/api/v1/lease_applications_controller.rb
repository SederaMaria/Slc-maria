class Api::V1::LeaseApplicationsController < Api::V1::ApiController
  skip_before_action :verify_authenticity_token, only: [:update_details, :create_welcome_call, :create_funding_delay, :create_reference]
  include UnderscoreizeParams

  respond_to :xml

  before_action :set_application, except: [:search, :repull_lessee_credit, :create, :get_details]
  before_action :set_application_by_id, only: [:get_details]

  def manufacturer
    render xml: GenerateXmlService.new(lease_application: @lease_application).generate_manufacturer_search_xml
  end

  def asset_model
    render xml: GenerateXmlService.new(lease_application: @lease_application).generate_asset_model_search_xml(params[:manufacturer_code])
  end

  def application
    render xml: GenerateXmlService.new(lease_application: @lease_application).generate_application_xml(params[:dealership_id], params[:manufacturer_code], params[:model_code])
  end

  def payment_schedule
    render xml: GenerateXmlService.new(lease_application: @lease_application).generate_payment_schedule_load_xml
  end

  def vendor
    render xml: GenerateXmlService.new(lease_application: "").generate_vendor_load_xml(params[:dealership_id])
  end

  def disbursement_date
    render xml: GenerateXmlService.new(lease_application: @lease_application).generate_disbursement_date_xml
  end

  def status
    render xml: GenerateXmlService.new(lease_application: @lease_application).generate_status_xml(params[:status])
  end

  def dealership_id
    dealership_id = @lease_application.present? ? "D#{@lease_application.dealer&.dealership_id}" : ""
    render json: {dealership_id: dealership_id}
  end

  def search
    query = params[:query]
    if query.present?
      lease_applications = LeaseApplication.whose_application_identifier_starts_with(query).limit(100)
    end
    render json: lease_applications.map{|x| {id: x.id, application_identifier: x.application_identifier}}.as_json
  end

  def get_details
    
    if @lease_application
      @lease_application.create_insurance if @lease_application.insurance.nil?
      # render json: LeaseApplicationSerializer.new(@lease_application).as_json
      render json: @lease_application, each_serializer: LeaseApplicationSerializer, adapter: :json, key_transform: :camel_lower, root: false
    else
      render json: {message: "Lease Application not found."}, status: :not_found
    end
  end

  def update_details

    merge_params = {}
    if lease_application_params.dig(:document_status)
      if (@lease_application.document_status != lease_application_params[:document_status]) && (lease_application_params[:document_status] == 'funding_approved')
        merge_params = {approved_by: current_user.id, requested_by: current_user.id}
      end
    end

    if @lease_application.update(lease_application_params.merge(merge_params))
      return_data = {}
      if lease_application_params.dig(:online_funding_approval_checklist_attributes, :package_reviewed) && lease_application_params[:online_funding_approval_checklist_attributes][:package_reviewed]
        @lease_application.online_funding_approval_checklist.update({ reviewed_by: current_user.id, package_reviewed_on: Time.zone.now })
        return_data = OnlineFundingApprovalChecklistSerializer.new(@lease_application.online_funding_approval_checklist).as_json
      end

      submitter = LeaseApplicationSubmitterService.new(lease_application: @lease_application, dealer_check: true)
      submitter.create_validations

      update_related_applications
      render json: {message: "Lease Application updated sucessfully", data: return_data}
    else
      render json: {message: @lease_application.errors.full_messages}, status: 500
    end
  end

  def update_related_applications
    attributes = lease_application_params[:lessee_attributes] || lease_application_params[:colessee_attributes]
    ssn_present = attributes&.key? :ssn
    if ssn_present
      lessee = Lessee.find_by_id(attributes[:id])
      if lessee
        lessee.update(ssn_changed: true)
        DetectRelatedApplicationsJob.perform_async(lessee.lease_application&.id)
      end
    end
  end

  #certified cycles app
  def create
    begin
      current_dealer = Dealer.find(ENV['SYSTEM_DEALER_ID'])
      lease_application = LeaseApplication.new(lease_application_params.merge!({
        dealership_id: current_dealer.dealership_id,
        dealer: current_dealer,
        vehicle_possession: 'primary_lessee',
        submitting_ip_address: request.remote_ip
      }))
      if lease_application.save
        lease_application_submission = PublicLeaseApplicationSubmitterService.new(lease_application: lease_application, dealer_check: false)
        if lease_application_submission.submit!(event_source: 'api/v1/lease-applications/create')
          current_dealer.update(current_sign_in_ip: request.remote_ip)
          render json: {message: "Lease Application submitted sucessfully" }
        else
          lease_application.delete
          render json: {message: lease_application_submission.errors.full_messages.to_sentence }, status: :internal_server_error
        end
      else
        Rails.logger.info(lease_application.errors.full_messages)
        render json: {message: lease_application.errors.full_messages.to_sentence}, status: :internal_server_error
      end
    rescue => exception
      Rails.logger.info(exception)
      render json: {message: "Error processing Application"}, status: :internal_server_error
    end
  end

  def create_welcome_call
    authorize(current_user, 'WelcomeCall', 'create')
    if @lease_application&.first_payment_date.nil?
      render json: {message: "Invalid First Payment Date"}, status: 400
    else

      if lease_application_params[:lease_application_welcome_calls_attributes][:welcome_call_status_id] == 3
        @lease_application.dealership.dealer_representatives.each do |representative|
          adminuser = AdminUser.find_by(email: representative.email)
          if @lease_application.welcome_call_due_date != lease_application_params[:lease_application_welcome_calls_attributes][:lease_application_due_date]&.to_date
            @lease_application.update_column(:welcome_call_due_date, lease_application_params[:lease_application_welcome_calls_attributes][:lease_application_due_date].to_date) 
          end
          this_lease_applicaton = LeaseApplication.find(@lease_application.id) #refetch to get update
          @lease_application.lease_application_welcome_calls.create(welcome_call_status_id: 3, admin_id: adminuser&.id, welcome_call_representative_type_id: 2, due_date: this_lease_applicaton.welcome_call_due_date)
          DealerRepresentativeMailer.welcome_call_request(recipient: representative, application: this_lease_applicaton).deliver_now
        end
        
      else
        welcome_call = @lease_application.lease_application_welcome_calls.create(lease_application_params[:lease_application_welcome_calls_attributes].merge!({ welcome_call_representative_type_id: 1, admin_id: current_user.id}))
      end

      unless lease_application_params[:lease_application_welcome_calls_attributes][:department] == @lease_application.department_id
        @lease_application.update(department: Department.find(lease_application_params[:lease_application_welcome_calls_attributes][:department]))
      end

      render json: {message: "Lease Application Welcome Call sucessfully created"}
    end

  end

  def create_funding_delay
    if @lease_application.funding_delays.create(lease_application_params[:funding_delays_attributes])
      render json: {message: "Lease Application Funding Delay sucessfully created"}
    else
      render json: {message: @lease_application.errors.full_messages}, status: 500
    end
  end

  def create_reference
    if @lease_application.references.create(lease_application_params[:references_attributes])
      render json: {message: "Reference sucessfully created"}
    else
      render json: {message: @lease_application.errors.full_messages}, status: 500
    end
  end

  def request_review
    authorize(current_user, 'LeaseWorkflowUnderwritingReview', 'create')
    workflow = WorkflowStatus.underwriting_review
    if @lease_application.update(workflow_status: workflow)
      @lease_application.notify_underwriting
      render json: {message: "Review successfully requested!"}
    else
      render json: {message: @lease_application.errors.full_messages}, status: 500
    end
  end

  def approve_underwritting
    authorize(current_user, 'LeaseWorkflowUnderwritingApprove', 'create')
    workflow = WorkflowStatus.find_by(description: 'Underwriting Approved')

    unless params[:comments].present?
      return render json: { message: "Comments is required!" }, status: :bad_request
    end

    # If this doesn't create a record, it should invalidate `@lease_application` and fail `update`
    @lease_application.lease_application_underwriting_reviews.create(
      admin_user: current_user,
      workflow_status: workflow,
      comments: params[:comments]
    )

    if @lease_application.update(workflow_status: workflow)
      render json: {message: "Review successfully approved!"}
    else
      render json: {message: @lease_application.errors.full_messages}, status: 500
    end
  end

  # GET        /api/v1/lease_applications/repull-lessee-credit
  def repull_lessee_credit
    begin
      if params[:lessee_id]
        RunBlackboxService.new(
          lessee_id: params[:lessee_id],
          fetch_type: :fill,
          request_type: :repull,
          blackbox_job_opts: { request_control: :manual_pull, request_event_source: 'api/v1/lease-applications/repull-lessee-credit' }
        ).run_lessee
        render json: {message: "Credit Reports Will Be Repulled and Appear as a File Attachment Shortly"}
      else 
        render json: {message: "Lessee Not Found"}, status: 500
      end
    rescue => exception
      Rails.logger.info(exception.message)
      Rails.logger.info(exception.backtrace)
      render json: {message: "Error processing Credit Reports"}, status: 500 
    end
  end

  # GET        /api/v1/lease_applications/repull-datax
  def repull_datax
    begin
      RunBlackboxService.new(
        lessee_id: @lease_application.lessee.id,
        fetch_type: :fill,
        request_type: :repull,
        blackbox_job_opts: { request_control: :manual_pull, request_event_source: 'api/v1/lease-applications/repull-datax' }
      ).run_lessee
      render json: {message: "Blackbox Will Be Repulled Shortly"}
    rescue => exception
      Rails.logger.info(exception.message)
      Rails.logger.info(exception.backtrace)
      render json: {message: "Error processing Blackbox"}, status: 500 
    end
  end

  # GET        /api/v1/lease_applications/generate-lease-package
  def generate_lease_package
    begin
      LeasePackageGeneratorJob.set(wait: 5.seconds).perform_later(application_id: @lease_application.id)
      render json: {message: "Your Lease Package will be generated and will appear as a File Attachment Shortly"}
    rescue => exception
      render json: {message: "Error processing Lease Package"}, status: 500 
    end
  end

  def resend_funding_request
    begin
      @lease_application.check_funding_request(override: true)
      render json: {message: "Your funding request has been submitted."}
    rescue => exception
      render json: {message: "Error processing Funding Request"}, status: 500 
    end
  end

  def welcome_call_due_date
    authorize(current_user, 'WelcomeCall', 'update')
    
    if lease_application_params[:welcome_call_due_date]&.to_date
      if @lease_application.update_column(:welcome_call_due_date, lease_application_params[:welcome_call_due_date]&.to_date)
        render json: {message: 'Welcome call due date updated'}
      else
        render json: {message: 'Error updating welcome call due date'}, status: 500
      end
    end
  end

  # POST       /api/v1/lease_applications/repull-colessee-credit
  def repull_colessee_credit
    if params[:colessee_id]
      blackbox_job_opts = { request_control: :manual_pull, request_event_source: 'api/v1/lease-applications/repull-colessee-credit' }
      RunBlackboxService.new(lessee_id: params[:colessee_id], fetch_type: :fill, request_type: :repull, blackbox_job_opts: blackbox_job_opts).run_lessee
      render json: { message: 'Credit Reports Will Be Repulled and Appear as a File Attachment Shortly' }
    else
      render json: { message: 'Colessee Not Found' }, status: 500
    end
  rescue => exception
    Rails.logger.info(exception.message)
    Rails.logger.info(exception.backtrace)
    render json: { message: "Error processing Credit Reports" }, status: 500
  end

  # PUT        /api/v1/lease_applications/swap-lessee
  def swap_lessee
    if LesseeAndColesseeSwapper.new(lease_application: @lease_application).swap!
      render json: { message: 'Swap successful' }
    else
      render json: { message: 'Could not perform swap, because colessee is not added' }, status: 500
    end
  end

  # POST       /api/v1/lease_applications/resend-credit-decision
  def resend_credit_decision
    unless @lease_application.notifications.credit_decision_emails.blank?
      @lease_application.notifications.credit_decision_emails.map(&:resend)
      render json: { message: 'Credit decision notification emails will now be resent.' }
    else
      render json: { message: 'Error processing action' }, status: 500
    end
  end

  # POST       /api/v1/lease_applications/generate-credit-decision-notifications
  def generate_credit_decision_notifications
    notification_attrs = {
      notification_mode:    'Email',
      notification_content: 'credit_decision',
      notifiable:           @lease_application
    }

    Notification.create_for_dealership(notification_attrs, dealership: @lease_application.dealership)

    render json: { message: 'Credit decision notification emails will now be sent to the dealership.' }
  end

  # PUT        /api/v1/lease_applications/remove-colessee
  def remove_colessee
    if ColesseeRemover.new(@lease_application).remove_colessee!
      render json: { message: 'Colessee removed' }
    else
      render json: { message: 'Could not remove colessee' }, status: 500
    end
  end

  # PUT        /api/v1/lease_applications/expire-lease-application
  def expire_lease_application
    unless @lease_application.expired?
      if @lease_application.update(expired: true)
        render json: { message: 'Lease application has been force expired' }
      else
        render json: { message: 'Could not expire this lease application' }, status: 500
      end
    else
      render json: { message: 'Lease application already expired' }, status: 500
    end
  end

  # PUT        /api/v1/lease_applications/unexpire-lease-application
  def unexpire_lease_application
    if @lease_application.expired?
      if @lease_application.update(expired: false)
        render json: { message: 'Lease application unexpired' }
      else
        render json: { message: 'Could not unexpire lease application' }, status: 500
      end
    else
      render json: { message: 'Lease application already expired' }, status: 500
    end
  end

  # POST       /api/v1/lease_applications/repull-credit-reports
  def repull_credit_reports
    blackbox_job_opts = { request_control: :manual_pull, request_event_source: 'api/v1/lease-applications/repull-credit-reports' }
    RunBlackboxService.new(lessee_id: @lease_application.lessee.id, fetch_type: :fill, request_type: :repull, blackbox_job_opts: blackbox_job_opts).run_lessee_colessee
    render json: { message: 'Credit Reports Will Be Repulled and Appear as a File Attachment Shortly.' }
  end

  # PUT        /api/v1/lease_applications/funding-approval-checklist
  def funding_approval_checklist
    file = FundingApprovalChecklist.generate(application: @lease_application)
    send_file file
  end

  private

  def set_application    
    @lease_application = LeaseApplication.where(application_identifier: lease_application_params[:application_identifier]).first
    render json: {message: "Lease Application not found."}, status: :not_found unless @lease_application.present?
  end

  def set_application_by_id
    @lease_application = LeaseApplication.find(lease_application_params[:id])
    render json: {message: "Lease Application not found."}, status: :not_found unless @lease_application.present?
  end

  def lease_application_params
    params.permit(
                  :id, :application_identifier, :document_status, :credit_status, :is_verification_call_completed, :funding_delay_on, :funding_approved_on, :funded_on, :lease_package_received_date,
                  :payment_bank_name, :payment_aba_routing_number, :payment_account_number, :payment_account_type, :payment_account_holder, :colessee_account_joint_to_lessee, 
                  :colessee_payment_bank_name, :colessee_payment_aba_routing_number, :first_payment_date, :payment_first_day, :second_payment_date, :payment_second_day, :payment_frequency,
                  :colessee_payment_account_number, :colessee_payment_account_type,
                  :is_dealership_subject_to_clawback, :this_deal_dealership_clawback_amount, :after_this_deal_dealership_clawback_amount, :dealership_commission_clawback_ammount,
                  :mail_carrier_id, :application_disclosure_agreement, :vehicle_possession, :welcome_call_due_date, :the_approver, :the_reviewer, :expired, :documents_issued_date, :documents_requested_date,
                  lease_calculator_attributes: [ :new_used, :asset_make,  :asset_year, :asset_model, :mileage_tier, :credit_tier_id ],
                  lessee_attributes: [ :id, :ssn, :email_address, :first_name, :middle_name, :last_name, :suffix, :date_of_birth, :mobile_phone_number, :home_phone_number, :ssn_changed,
                                       :drivers_license_id_number, :at_address_months, :home_ownership, :employer_name, :employer_phone_number, :employment_status, :time_at_employer_months, 
                                       :time_at_employer_years, :time_at_employer_years, :gross_monthly_income, :proven_monthly_income, :at_address_years, :monthly_mortgage, :job_title,
                                      home_address_attributes: [:id, :street1, :street2, :city, :state, :zipcode, :county, :city_id],
                                      mailing_address_attributes: [:id, :street1, :street2, :city, :state, :zipcode, :county, :city_id],
                                      employment_address_attributes: [:id, :city, :state],
                                    ],
                 colessee_attributes: [ :id, :ssn, :email_address, :first_name, :middle_name, :last_name, :suffix, :date_of_birth, :mobile_phone_number, :home_phone_number, :ssn_changed,
                                      :drivers_license_id_number, :at_address_months, :home_ownership, :employer_name, :employer_phone_number, :employment_status, :time_at_employer_months, 
                                      :time_at_employer_years, :time_at_employer_years, :gross_monthly_income, :proven_monthly_income, :at_address_years, :monthly_mortgage, :job_title,
                                     home_address_attributes: [:id, :street1, :street2, :city, :state, :zipcode, :county, :city_id],
                                     mailing_address_attributes: [:id, :street1, :street2, :city, :state, :zipcode, :county, :city_id],
                                     employment_address_attributes: [:id, :city, :state]
                                   ],
                  funding_delays_attributes: [ :id, :funding_delay_reason_id, :status, :notes ],
                  lease_application_stipulations_attributes: [ :id, :stipulation_id, :status, :notes, :lease_application_attachment_id ],
                  lease_application_welcome_calls_attributes: [:id, :welcome_call_status_id, :department, :welcome_call_type_id, :welcome_call_result_id, :lease_application_due_date, :notes ],
                  insurance_attributes: [ :company_name, :property_damage, :bodily_injury_per_person, :bodily_injury_per_occurrence, :comprehensive, :collision, :effective_date, :expiration_date, :policy_number, :loss_payee, :additional_insured ],
                  references_attributes: [ :id, :first_name, :last_name, :phone_number, :created_at, :updated_at, :city, :state, :phone_number_line, :phone_number_carrier ],
                  online_funding_approval_checklist_attributes: [ :id, :no_markups_or_erasure, :lease_agreement_signed, :motorcycle_condition_reported, :credit_application_signed, :four_references_present, :valid_dl, :ach_form_completed, :insurance_requirements, :valid_email_address, :registration_documents_with_slc, :ods_signed_and_dated, :proof_of_amounts_due, :documentation_to_satisfy, :warranty_products_purchased, :signed_bos, :package_reviewed ],
                  decline_reasons_attributes: [:id, :description, :_destroy]
                )
  end
end
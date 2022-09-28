class PublicLeaseApplicationSubmitterService
    include ActiveModel::Validations
  
    attr_reader :application, :lessee, :dealer_check, :lease_calculator
  
    delegate :first_name, :last_name, :home_phone_number, :mobile_phone_number, :employer_phone_number,
      :monthly_mortgage, :home_ownership, :date_of_birth, :ssn, :employer_name,
      :employment_status, :employer_phone_number, :gross_monthly_income, :at_address_years,
      :home_address, :employment_address, :mailing_address, :email_address,
      to: :lessee, prefix: true, allow_nil: true
    
  
    delegate :credit_status, :expired, :vehicle_possession, to: :application, prefix: true, allow_nil: true
  
    delegate :street1, :city_id, :state, :zipcode,
      to: :lessee_home_address, prefix: true, allow_nil: true
  
  
    delegate :city, :state,
      to: :lessee_employment_address, prefix: true, allow_nil: true
  
    delegate :us_state, :tax_jurisdiction, :asset_make, :asset_year, :asset_model, :mileage_tier,
      to: :lease_calculator, prefix: true, allow_nil: true
    
      validates :lease_calculator_us_state,
                :lease_calculator_asset_make,
                :lease_calculator_asset_year,
                :lease_calculator_asset_model,
                :lease_calculator_mileage_tier,
                presence: true

    validates :lessee_first_name,
              :lessee_last_name,
              :lessee_monthly_mortgage,
              :lessee_home_ownership,
              :lessee_date_of_birth,
              :lessee_ssn,
              :lessee_employer_name,
              :lessee_employment_status,
              :lessee_employer_phone_number,
              :lessee_at_address_years,
              :lessee_home_address_street1,
              :lessee_home_address_city_id,
              :lessee_home_address_state,
              :lessee_home_address_zipcode,
              :lessee_employment_address_city,
              :lessee_employment_address_state,
              presence: true
              
    validates :lessee_email_address,
              presence: true,
              if: :require_primary_email_address? 
              
  
    validates :application_credit_status, 
      inclusion: {in: %w(draft unsubmitted), message: 'must be unsubmitted' }
    
    validates :application_expired,
      inclusion: { in: [false], message: 'must be false' }
  
    validates :application_vehicle_possession, presence: true
  
    validate do |service_object|
      unless service_object.lessee_home_phone_number.present? || service_object.lessee_mobile_phone_number.present?
        service_object.errors[:base] << "Lessee must provide either a home or mobile phone number."
      end
    end
  
  
    # Check if user has an active application in the same dealership
    validate do |service_object|
      if dealer_check
        # active_applications = LeaseApplication.submitted.not_expired.by_lessee_ssn(service_object.lessee_ssn).where(dealership_id: application.dealership_id)
        # active_applications = LeaseApplication.submitted.not_expired.by_lessee_ssn_dealership(service_object.lessee_ssn,application.dealership_id, service_object.lessee.first_name, service_object.lessee.date_of_birth).where(dealership_id: application.dealership_id)
        active_applications = LeaseApplication.submitted.not_expired.by_lessee_ssn_dealership(service_object.lessee_ssn,application.dealership_id).where(dealership_id: application.dealership_id)
        if active_applications.any?
          service_object.errors[:base] << "Application ##{active_applications.first.application_identifier} has already been submitted and can not be resubmitted yet. Please make any changes you require to that application, or call Underwriting at 844-390-0717 with any questions."
        end
      end
    end
  
    def initialize(lease_application:, dealer_check: false)
      @application = lease_application
      @lessee = lease_application.lessee
      @lease_calculator = lease_application.lease_calculator
      @dealer_check = dealer_check
    end
  
    #bang methods usually denotes a method that could raise an error if/when its unsuccessful.
    #We should rename this to just `submit` and it should return true/false depending on whether it finished successfully or not.
    def submit!(**options)
      return false unless valid?
  
      # assigning next application identifier if application identifier is blank
      if application.application_identifier.blank?
        new_application_identifier = next_application_identifier
        log("assigning application_identifier to ID#{application.id} -> #{new_application_identifier}")
        application.application_identifier = new_application_identifier
        log("application_identifier has been set for ID#{application.id}: #{application.application_identifier}")
      end
  
      LeaseApplication.transaction do
        application.submit
        application_submission_status = false
        log("Submission status #{application_submission_status}")
        if application.save
          application_submission_status = true
          update_workflow_status
          log("Submission status #{application_submission_status}")
          notify_dealer_and_speed_leasing
          enqueue_related_applications_detection
          create_address_validations
          create_phone_number_validations
          create_email_validations
          unless ENV['CREDCO_DISABLED'] == 'yes'
            enqueue_lessee_credit_report_pull(options[:event_source])
            log("Enqueue Credit report")
          end
          create_required_stipulations
          log("Create stipulation done")
        end
        return application_submission_status
      end
    end
  
    def create_address_validations
      if lessee.present? && lessee.home_address.present?
        AddressValidation.create(validatable: lessee.home_address, lease_application: application).verify
      end
      if lessee.present? && lessee.mailing_address.present?
        AddressValidation.create(validatable: lessee.mailing_address, lease_application: application).verify
      end
    end
  
    def create_phone_number_validations
      if lessee_home_phone_number.present?
        HomePhoneValidation.create(validatable: lessee, lease_application: application).verify
      end
      if lessee_mobile_phone_number.present?
        MobilePhoneValidation.create(validatable: lessee, lease_application: application).verify
      end
      if lessee_employer_phone_number.present?
        EmployerPhoneValidation.create(validatable: lessee, lease_application: application).verify
      end
    end
  
    def create_email_validations
      if lessee.present? && lessee.email_address.present?
        EmailValidation.create(validatable: lessee, lease_application: application).verify
      end
    end
  
    def create_required_stipulations
      Stipulation.post_submission_required.each do |stipulation|
        application.lease_application_stipulations.create(stipulation: stipulation, status: 'Required')
      end
    end
  
    def enqueue_lessee_credit_report_pull(event_source)
      # CreditReportJob.perform_async(lessee.id)
      # Any Blackbox request related to "Submit to Speedleasing" is considered "automatic"
      # Thus, we only need to know where it came from (`event_source`)
      RunBlackboxService.new(
        lessee_id: lessee.id,
        fetch_type: :fill,
        blackbox_job_opts: { request_control: :auto_pull, request_event_source: event_source }
      ).run_lessee
    end
  
    def enqueue_related_applications_detection
      DetectRelatedApplicationsJob.perform_async(application.id)
    end
  
    def require_primary_email_address?
      CommonApplicationSetting&.first&.require_primary_email_address
    end
  
    def notify_dealer_and_speed_leasing
      LeaseApplicationSubmitMailerJob.perform_in(1.minute, application_id: application.id)
      Notification.create_for_admins(
        notification_mode: 'InApp',
        notification_content: 'application_submitted', 
        notifiable: application
      )
    end
  
    #Should be its own service object that assigns the next number onto the lease application
    def next_application_identifier
      next_application_identifier_func = LeaseApplication.connection.execute <<-SQL
        SELECT next_application_identifier_func() as next_application_identifier;
      SQL
      next_application_identifier_func.first["next_application_identifier"][-10,10]
    end
    
    def log(msg)
      CustomLogger.log_info("#{self.class.to_s}", msg)
    end
    

    def update_workflow_status
      application.update(workflow_status_id: WorkflowStatus.underwriting&.id)
    end

  end
  
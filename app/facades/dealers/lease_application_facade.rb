module Dealers
  class LeaseApplicationFacade #polish for where to dump disorganized code
    attr_reader :lease_application, :dealer, :dealer_check

    def initialize(lease_application: nil, dealer: nil, dealer_check: false)
      @lease_application = lease_application
      @dealer            = dealer
      @dealer_check      = dealer_check
    end

    def rescind_application!
      if lease_application.rescind!
        Notification.create_for_dealership({
          notification_mode: 'Email',
          notification_content: 'credit_decision',
          notifiable: lease_application 
        }, dealership: lease_application.dealership)
        return { notice: 'Rescind successful' }
      else
        return { alert: 'Could not rescind this application' }
      end
    end

    def submit_application!(**options)
      lease_application_submission = LeaseApplicationSubmitterService.new(lease_application: lease_application, dealer_check: dealer_check)
      if lease_application_submission.submit!(options)
        return { notice: 'Application submitted' }
      else
        # format alert message here?
        # bang methods shouldn't be returning a hash. Maybe move the message setting to the controller?
        return { alert: lease_application_submission.errors.full_messages.to_sentence }
      end
    end

    def swap_lessee!
      if LesseeAndColesseeSwapper.new(lease_application: lease_application).swap!
        return { notice: 'Swap successfull' }
      else
        return { alert: 'Could not perform swap, because colessee is not added' }
      end
    end

    def bike_change!(params)
      BikeChangeSubmitterService.new(lease_calculator: lease_application.lease_calculator).bike_change(params)
    end

    def build_app
      lessee = Lessee.new
      insurance = Insurance.new
      lessee.home_address = Address.new
      lessee.mailing_address = Address.new
      lessee.employment_address = Address.new
      colessee = Lessee.new
      colessee.home_address = Address.new
      colessee.mailing_address = Address.new
      colessee.employment_address = Address.new
      lease_calculator = LeaseCalculator.new
      LeaseApplication.new(
        lessee: lessee,
        colessee: colessee,
        insurance: insurance,
        lease_calculator: lease_calculator
      )
    end

    def load_app
      insurance = lease_application.insurance || lease_application.build_insurance
      lessee = lease_application.lessee || lease_application.build_lessee
      lessee.build_home_address unless lessee.home_address
      lessee.build_mailing_address unless lessee.mailing_address
      lessee.build_employment_address unless lessee.employment_address
      colessee = lease_application.colessee || lease_application.build_colessee
      colessee.build_home_address unless colessee.home_address
      colessee.build_mailing_address unless colessee.mailing_address
      colessee.build_employment_address unless colessee.employment_address
      lease_application
    end
  end
end

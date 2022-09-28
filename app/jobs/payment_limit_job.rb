class PaymentLimitJob
    include Sidekiq::Worker
    sidekiq_options unique: :until_executing,
                    retry: 5
    GROSS = 'gross'.freeze
    NET = 'net'.freeze
  
    def perform(app_id)
      @lease_application = LeaseApplication.find app_id
      @lessee = @lease_application&.lessee
      @colessee = @lease_application&.colessee
      @logger = Logger.new(STDOUT)
      if @lease_application
        calculate_payment_limit
      else
        CustomLogger.log_info("#{self.class.to_s}#perform", " record not found for lease_application")
      end
    end

    private

    def calculate_payment_limit
        proven_monthly_income = get_income_verifications.map{ |income| convert_income_by_frequncy(income) }.compact&.sum
        #maximum payment percentage
        payment_limit_percentage = @lease_application&.lease_calculator&.credit_tier_v2&.payment_limit_percentage.to_f / 100
        max_allowable_payment = proven_monthly_income * payment_limit_percentage
        total_monthly_payment = @lease_application&.lease_calculator&.total_monthly_payment
        variance = max_allowable_payment - total_monthly_payment

        @logger.info("proven_monthly_income - #{proven_monthly_income}")
        @logger.info("max_allowable_payment - #{max_allowable_payment}")
        @logger.info("total_monthly_payment - #{total_monthly_payment}")
        @logger.info("variance - #{variance}")


        @lease_application.lease_application_payment_limits.create(
            credit_tier_id: @lease_application&.lease_calculator&.credit_tier_v2&.id,
            proven_monthly_income: proven_monthly_income, 
            total_monthly_payment: total_monthly_payment,
            max_allowable_payment: max_allowable_payment,
            variance: variance
        ) 

        update_to_underwriting_review(variance)
    end


    def update_to_underwriting_review(variance)
        if variance < 0
            workflow = WorkflowStatus.underwriting_review
            unless @lease_application.workflow_status_id == workflow.id
                @lease_application.update(workflow_status: workflow)
                @lease_application.notify_underwriting
            end
          end
    end


    def get_income_verifications
        return @lessee.income_verifications if @colessee.nil?
        return IncomeVerification.where(lessee_id: [@lessee&.id, @colessee&.id].compact)
    end


    def is_lessee_same_address
        return false unless @colessee.peresent?
        return true if address(@colessee)&.id == address(@lessee)&.id
    end

    def address(_lessee)
        _lessee&.home_address&.new_city
    end

    def convert_income_by_frequncy(income)
        return 0 if income&.gross_income&.nil? || income&.gross_income&.zero?
        calculated_income = case income&.income_frequency&.income_frequency_name
                            when 'Weekly'
                              income.gross_income * 52 / 12
                            when 'Bi-Weekly'
                              income.gross_income * 2 * 52 /12
                            when 'Monthly'
                              income.gross_income
                            when 'Yearly'
                              income.gross_income / 12
                            end
        return calculated_income if income&.income_type == GROSS

        calculated_income / 0.85 if income&.income_type == NET
    end
end



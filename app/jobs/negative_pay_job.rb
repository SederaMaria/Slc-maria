class NegativePayJob
    include Sidekiq::Worker
    sidekiq_options unique: :until_executing
    
    def perform(lessee_id)
      @lessee = Lessee.find lessee_id
      @lease_application = @lessee.lease_application
      if @lease_application
        fetch_datax(@lessee)
      else
        CustomLogger.log_info("#{self.class.to_s}#perform", " record not found for lease_application #{lease_application_id}")
      end
    end
    
    private
    
    def fetch_datax(lessee)
      applicant_type = "applicant"
      applicant_type = "coapplicant" if lessee.id == @lease_application.colessee&.id
      is_staging = (Rails.env.production? && Rails.application.routes.default_url_options[:host].include?("staging"))
      is_dev_and_staging = is_staging || Rails.env.development? 
      is_3_zero = (lessee&.ssn&.first(3) == "000")
      
      payload = {
        "campaignID" =>  ENV['LEADROUTER_CAMPAIGNID_NEGATIVE_PAY'],
        "loanAmount" => @lease_application&.lease_calculator&.calculate_gross_capitalized_cost.to_f,
        "ipAddress" => @lease_application&.dealer&.current_sign_in_ip.to_s,
        "sourceURL" => Rails.application.routes.default_url_options[:host],
        "ssn" => lessee&.ssn,
        "firstName" => lessee&.first_name,
        "lastName" => lessee&.last_name,
        "streetAddress" => lessee&.home_address&.street1,
        "city" => lessee&.home_address&.new_city_value,
        "state" => lessee&.home_address&.new_state_value,
        "zipCode" => lessee&.home_address&.zipcode,
        "dateOfBirth" => lessee&.date_of_birth&.strftime("%F"),
        "monthlyIncome" => lessee&.gross_monthly_income.to_s.first(5).to_i,
        "priorCreditScore" => lessee&.last_successful_credit_report&.credit_score_average,
        "employer" => lessee&.employer_name,
        "applicantType" => applicant_type,
        "bankAccountType" => @lease_application.payment_account_type,
        "bankRoutingNumber" => @lease_application.payment_aba_routing_number,
        "bankAccountNumber" => @lease_application.payment_account_number,
        "bankName" => @lease_application.payment_bank_name,
      }
      
      payload.merge!({ "mobilePhone" => lessee&.mobile_phone_number.gsub(/[^0-9A-Za-z]/, '') }) unless lessee&.mobile_phone_number.empty?
      payload.merge!({ "homePhone" => lessee&.home_phone_number.gsub(/[^0-9A-Za-z]/, '') }) unless lessee&.home_phone_number.empty?
      CustomLogger.log_info("#{self.class.to_s}#fetch_datax", " payload - #{payload}") unless Rails.env.production? 
      
      data = JSON.parse(RestClient::Request.execute(method: :post, url: ENV['BLACKBOX_FINALIZE_URL'],proxy: ENV['QUOTAGUARDSTATIC_URL'], payload: payload))   
      CustomLogger.log_info("#{self.class.to_s}#fetch_datax", " data - #{data}")                                    
      
      negative_pay = @lease_application.negative_pays.create(
        payment_bank_name: @lease_application.payment_bank_name,
        payment_account_type: @lease_application.payment_account_type,
        payment_account_number: @lease_application.payment_account_number,
        payment_aba_routing_number: @lease_application.payment_aba_routing_number,
        response: data, 
        request: payload, 
        lessee: lessee
      )
    
    end
  
  end
  
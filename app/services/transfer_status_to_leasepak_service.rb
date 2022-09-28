require 'rest-client'

class TransferStatusToLeasepakService

  def initialize(lease_application:)
    @lease_application = lease_application
    @url = ENV['BRIDGING_API_URL']
  end

  def transfer
    CustomLogger.log_info("#{self.class.to_s}#transfer", "Started Update processing for Lease Application: #{@lease_application.application_identifier} with document status #{@lease_application.document_status}")
    if (@lease_application.document_status == 'funded' && @lease_application.funded_on.present?)
      load_split_payments_schedule_to_leasepak(@lease_application)
      update_disbursement_date_to_leasepak(@lease_application)
      response = JSON.parse(RestClient.get "#{@url}/status_transfer/update?app_number=#{@lease_application.application_identifier}")
      errors = check_for_errors(response)
      if errors.present?
        LeasepakMailer.failure_email(@lease_application.application_identifier, errors, 'second_status_transfer_call').deliver_later
      end
    else      
      response = JSON.parse(RestClient.get "#{@url}/status_transfer?app_number=#{@lease_application.application_identifier}")
      # update_dealership_commission_clawback_amount(@lease_application)
      errors = check_for_errors(response, 'transfer')
      if errors.present?
        #send failure email
        LeasepakMailer.failure_email(@lease_application.application_identifier, errors, 'status_transfer').deliver_later
      end
    end
    
    File.open('log/leasepak_transfer.log', 'a') do |line|
      line.puts "\r" + "Status Transfer Processed at #{Time.now},APP: #{@lease_application.application_identifier}, RESPONSE: #{response}"
    end
    CustomLogger.log_info("#{self.class.to_s}#transfer","Completed Update processing for Lease Application: #{@lease_application.application_identifier}, RESPONSE: #{response}")
  end

  private

  # def update_dealership_commission_clawback_amount(app)
  #   return unless app.dealership.is_commission_clawback?
  #   dealership_clawback_amount = app.dealership.commission_clawback_amount
  #   #clawback_amount = app.amount > dealership_clawback_amount ? 0 : dealership_clawback_amount - app.amount
  #   app.dealership.update_column(:commission_clawback_amount, dealership_clawback_amount)
  # end

  def update_disbursement_date_to_leasepak(app)
    response = JSON.parse(RestClient.get "#{@url}/update_disbursement_date?app_number=#{@lease_application.application_identifier}")
    errors = check_for_errors(response)
    if errors.present?
      #send failure email
      LeasepakMailer.failure_email(@lease_application.application_identifier, errors, 'update_disbursement_date').deliver_later
    end
    CustomLogger.log_info("#{self.class.to_s}#update_disbursement_date_to_leasepak","Response for update disbursement date for application no. #{@lease_application.application_identifier} /n #{response}")
  end

  def load_split_payments_schedule_to_leasepak(app)
    if(app.payment_frequency == 'split')
      response = JSON.parse(RestClient.get "#{@url}/load_pay_schedule_to_leasepak?app_number=#{@lease_application.application_identifier}")
      errors = check_for_errors(response)
      if errors.present?
        #send failure email
        LeasepakMailer.failure_email(@lease_application.application_identifier, errors, 'load_pap_schedule').deliver_later
      end
      CustomLogger.log_info("#{self.class.to_s}#load_split_payments_schedule_to_leasepak","Response for load payment schedule for application no. #{@lease_application.application_identifier} /n #{response}")
    end  
  end

  def check_for_errors(response, type = '')
    errors = []

    if response['type'] == 'error' && response['response_returned'].present?
      
      parsed_hash = Hash.from_xml(response['response_returned'].to_s)
      if parsed_hash['MSI_APP_ORIG_MSGS'].present?
        parsed_hash['MSI_APP_ORIG_MSGS']['RESULT_RECORD'].each do |response|
          if response['TYPE'] == 'ERROR'
            errors << response['MSGTEXT']
          end
        end
      end

      if parsed_hash['LP_RESPONSE_INFO'].present?
        if parsed_hash['LP_RESPONSE_INFO']['RESULT_RECORD'].present?
          if parsed_hash['LP_RESPONSE_INFO']['RESULT_RECORD']['TYPE'] == 'ERROR'
            errors << parsed_hash['LP_RESPONSE_INFO']['RESULT_RECORD']['MSGTEXT']
          end
        end
      end

      if parsed_hash['APP_STATUS_XFER_FETCH'].present?
        errors << parsed_hash['APP_STATUS_XFER_FETCH']['ERROR']
      end

      if parsed_hash['APP_STATUS_XFER'].present?
        errors << parsed_hash['APP_STATUS_XFER']['ERRORS']
      end

    end
    errors.reject(&:blank?)
  end
end

class PrenoteJob
  include Sidekiq::Worker
  sidekiq_options unique: :until_executing
  sidekiq_options retry: 2

  def perform(lease_application_id)
    @lease_application = LeaseApplication.find lease_application_id
    if @lease_application
      fetch_prenote(@lease_application)
    else
      CustomLogger.log_info("#{self.class.to_s}#perform", " record not found for lease_application #{lease_application_id}")
    end
  end

  def fetch_prenote(app)
    prenote_status = 'not attempted'
    usio_status = 'succeess'
    payload = {
      'MerchantID'        => ENV['USIO_ACH_MERCHANT_ID'],
      'Login'             => ENV['USIO_ACH_LOGIN'],
      'Password'          => ENV['USIO_ACH_PASSWORD'],
      'RoutingNumber'     => app&.payment_aba_routing_number,
      'AccountNumber'     => app&.payment_account_number,
      'TransCode'         => ENV['USIO_ACH_PAYMENT_TRANSCODE'],
      'Amount'            => ENV['USIO_ACH_PAYMENT_AMOUNT'],
      'FirstName'         => app&.lessee&.first_name,
      'LastName'          => app&.lessee&.last_name,
      'StandardEntryCode' => ENV['USIO_ACH_STANDARD_ENTRY_CODE']
    }
    begin
      request = RestClient.post(ENV['USIO_ACH_PAYMENT_URL'], payload.to_json, {content_type: :json, accept: :json})
      prenote_status = 'pending'
    rescue => e
      CustomLogger.log_info("#{self.class.to_s}#fetch_prenote", "Response Error #{self.class.to_s}#fetch_prenote #{e.message}")
      usio_status = 'failure'
    end
    data = JSON.parse(request)
    CustomLogger.log_info("#{self.class.to_s}#fetch_prenote", " data - #{data}")
    usio_status = 'failure' if (data['Message'].downcase == 'failure') 
    @lease_application.prenotes.create(
      response: data,
      usio_confirmation_number: data['Confirmation'],
      usio_message: data['Message'],
      usio_status: usio_status,
      prenote_status: prenote_status
    )
    @lease_application.update(prenote_status: prenote_status)
  end

end
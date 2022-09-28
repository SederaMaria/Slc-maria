class PhoneNumberServices
  attr_reader :client
  attr_accessor :error_message, :number

  def initialize(number)
    @number = number
  end

  def valid?
    begin
      @number.present? && phone_numbers&.national_format.present? && phone_numbers&.country_code.present?
    rescue => e
      @error_message = e.message
      false
    end
  end

  def carrier_lookup
    @carrier_lookup_result ||= phone_numbers&.carrier.to_h
  end

  def phone_numbers
    @phone_numbers ||= client.lookups.phone_numbers(number)&.fetch(type: ['carrier'])
  end

  def client
    @client ||= Twilio::REST::Client.new(ENV['TWILIO_ACCOUNT_SID'], ENV['TWILIO_AUTH_TOKEN'])
  end
end

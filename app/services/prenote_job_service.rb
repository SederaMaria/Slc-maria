class PrenoteJobService

  HEADERS = { content_type: :json, accept: :json }
  TRANSACTIONAL_API_URL = ENV['UISO_TRANSACTIONAL_API_URL']
  SUCCESS               = 'success'.freeze
  PENDING               = 'pending'.freeze
  NO_RETURN             = 'no return'.freeze
  UNKNOWN               = 'unknown'.freeze
  FAILURE               = 'failure'.freeze
  CHANGE                = 'notice of change'.freeze
  NOT_ATTEMTED          = 'not attempted'.freeze

  def call
    call_usio_transactional_api
    update_prenote_request
    mark_prenote_as_no_return
  end

  attr_accessor :response

  private

  def call_usio_transactional_api
    begin
      request = RestClient.post(TRANSACTIONAL_API_URL, payload.to_json, HEADERS )
    rescue => e
      raise("#{self.class.to_s}#perform #{e.message}") 
    end
    @response = JSON.parse(request.body)
    CustomLogger.log_info("#{self.class.to_s}#fetch_prenote", " response - #{response}")
  end


  def payload
    {
      'MerchantID'        => ENV['USIO_ACH_MERCHANT_ID'],
      'Login'             => ENV['USIO_ACH_LOGIN'],
      'Password'          => ENV['USIO_ACH_PASSWORD'],
      "DateFrom"          => 15.days.ago.strftime("%m/%d/%Y %H:%M:%S"),
      "DateTo"            => Time.now.strftime("%m/%d/%Y %H:%M:%S"),
      'FilterOptions'     => ENV['USIO_ACH_FILTER_OPTIONS']
    }    
  end

  def update_prenote_request
    return if response['Status'] == FAILURE || response['Transactions'].empty?
    response['Transactions'].each do |transaction|
      prenote = Prenote.find_by(usio_confirmation_number: transaction['Confirmation'])

      if prenote
        prenote_message = "#{transaction['FinalStatus']}"
        case transaction['FinalStatus']
        when nil
          prenote_status = UNKNOWN
        when 'XXX', '1912', '1100'
          prenote_status = FAILURE
          prenote_message << " #{UsioReturnCode.find_by(code: transaction['FinalStatus'])&.description}"
        else

          if transaction['FinalStatus'].first == 'C'
            prenote_message << " #{NachaNocCode.find_by(code: transaction['FinalStatus'])&.description}"
            prenote_status = CHANGE
          elsif transaction['FinalStatus'].first == 'R'
            prenote_message << " #{NachaReturnCode.find_by(code: transaction['FinalStatus'])&.description || RemoteCheckReturnCode.find_by(code: transaction['FinalStatus'])&.description}"
            prenote_status = FAILURE
          else
            prenote_status = UNKNOWN
          end

        end

        prenote.update(
          usio_status: SUCCESS,
          usio_transaction_response: transaction,
          prenote_status: prenote_status,
          prenote_message: prenote_message
        )
        prenote.lease_application.update_attribute(:prenote_status, prenote_status)

        if [NOT_ATTEMTED, CHANGE, FAILURE, UNKNOWN].include?(prenote_status) && !prenote.email_notification_sent
          PrenoteResponseMailer.prenote_response(email: ENV['FUNDING_EMAIL'], prenote: prenote).deliver_now
          prenote.update(email_notification_sent: true)
        end

      end
    end
  end

  def mark_prenote_as_no_return
    todays_date = Date.today
    days_ago = nil
    case todays_date.strftime("%A")
    when 'Tuesday', 'Monday', 'Wednesday', 'Sunday'
      days_ago = 6
    when 'Saturday'
      days_ago = 5
    else
      days_ago = 4
    end
    query_day = todays_date - days_ago 
    prenotes = Prenote.where('date(created_at) <= ? AND prenote_status =?', query_day, PENDING)
    lease_application_ids = prenotes.pluck(:lease_application_id)
    prenotes.update_all(prenote_status: NO_RETURN)
    LeaseApplication.where(id: lease_application_ids).update_all(prenote_status: NO_RETURN)
  end
  
  
end
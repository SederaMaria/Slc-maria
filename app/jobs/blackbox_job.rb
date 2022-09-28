class BlackboxJob
  include Sidekiq::Worker
  sidekiq_options unique: :until_executing,
                  retry: 5

  # https://github.com/mperham/sidekiq/issues/2372
  # If using `perform_async` or other `Sidekiq::Worker` class-specific methods, update keyword arguments to required/optional arguments
  def perform(lessee_id: , fetch_type: :finalize, request_type: :new, **options)
    @lessee = Lessee.find lessee_id
    @lease_application = @lessee.lease_application
    @fetch_type = fetch_type
    @logger = Logger.new(STDOUT)
    @request_type = request_type
    @options = options
    if @lease_application
      fetch_leadrouter(@lessee)
    else
      CustomLogger.log_info("#{self.class.to_s}#perform", " record not found for lease_application")
    end
  end
  
  private
  
  def fetch_leadrouter(lessee)
    payload = generate_payload(lessee)

    if @fetch_type == :fill
      begin
        fill_data = JSON.parse(RestClient::Request.execute(method: :post, url: ENV['BLACKBOX_FILL_URL'],proxy: ENV['QUOTAGUARDSTATIC_URL'],
          payload: payload.to_json,
          headers: {:Authorization => "Token #{ENV['BLACKBOX_FILL_TOKEN']}", content_type: :json} ))

        blackbox = create_blackbox_for_fill(lessee, fill_data, payload)
        email_for_blackbox_auto_reject(blackbox)
        generate_adverse_reason_codes(blackbox, fill_data)
        generate_error_details(blackbox, fill_data)

        address_list = blackbox.leadrouter_response.dig("extraAttributes", "tlo_person_search_address_list", "Addresses", "BasicAddressRecord")
        create_lease_application_blackbox_tlo_person_search_addresses(blackbox, address_list)

      rescue => e
        @logger.info(e.message)
        @logger.info(e.backtrace)
        # If request failed to reach server (or other exceptions)
        CustomLogger.log_info("#{self.class.to_s}#fetch_leadrouter", "api - #{@fetch_type}, Error - #{e}")
      end
      
      run_credit_report_job(lessee)
    else
      begin
        data = JSON.parse(RestClient::Request.execute(method: :post, url: ENV['BLACKBOX_FINALIZE_URL'],proxy: ENV['QUOTAGUARDSTATIC_URL'], payload: payload))   
        CustomLogger.log_info("#{self.class.to_s}#fetch_leadrouter", "api - #{@fetch_type}, data - #{data}")
    
        blackbox = create_blackbox_for_finalize(lessee, data, payload)
        email_for_blackbox_auto_reject(blackbox)
        blackbox_model_detail = get_blackbox_model_detail(blackbox_model.id, data["creditScore"].to_i)
        generate_lessee_recommended_blackbox_tier(lessee, blackbox, blackbox_model_detail)
        generate_lease_applicaton_recommened_blackbox_tier(blackbox_model_detail)

        generate_adverse_reason_codes(blackbox, data)
        generate_error_details(blackbox, data)
        generate_employment_search(blackbox, data)
      rescue => e
        @logger.info(e.message)
        @logger.info(e.backtrace)
        # If request failed to reach server (or other exceptions)
        CustomLogger.log_info("#{self.class.to_s}#fetch_leadrouter", "api - #{@fetch_type}, Error - #{e}")
      end
    end
  end

  # Non-empty & alphanumeric string (ex. "null") would be saved as 0
  # Thus, try match if it only contains numerical characters, else `nil`
  def safe_to_i(value)
    value&.to_s&.match(/^\d+$/) ? value : nil
  end


  def generate_payload(lessee)
    applicant_type = "applicant"
    applicant_type = "coapplicant" if lessee.id == @lease_application.colessee&.id
    is_staging = (Rails.env.production? && Rails.application.routes.default_url_options[:host].include?("staging"))
    is_dev_and_staging = is_staging || Rails.env.development? 
    is_3_zero = (lessee&.ssn&.first(3) == "000")
    
    payload = {
      "campaignID" =>  is_dev_and_staging ? ENV['LEADROUTER_CAMPAIGNID_TEST'] : (is_3_zero ? ENV['LEADROUTER_CAMPAIGNID_TEST'] : ENV['LEADROUTER_CAMPAIGNID']),
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
      "title" => lessee&.job_title,
      "applicantType" => applicant_type
    }

    payload.merge!({
      "buyerIDScore" => @lease_application&.lease_application_credco&.borrower_id_score,
      "openAutoMonthlyPayment" => @lease_application&.lease_application_credco&.open_auto_monthly_payment,
      "revolvingCreditAvailable" => @lease_application&.lease_application_credco&.revolving_credit_available,
      "leadID" => @lease_application&.lease_application_blackbox_requests&.where(lessee: lessee)&.last&.leadrouter_lead_id,
    }) if @fetch_type == :finalize

    payload.merge!({ "mobilePhone" => lessee&.mobile_phone_number&.gsub(/[^0-9A-Za-z]/, '') }) unless lessee&.mobile_phone_number&.empty?
    payload.merge!({ "homePhone" => lessee&.home_phone_number&.gsub(/[^0-9A-Za-z]/, '') }) unless lessee&.home_phone_number&.empty?
    CustomLogger.log_info("#{self.class.to_s}#fetch_leadrouter", "api - #{@fetch_type}, payload - #{payload}") unless Rails.env.production?
    @logger.info("#{self.class.to_s}#fetch_leadrouter - api - #{@fetch_type}, payload - #{payload}")
    payload
  end


  def create_blackbox_for_fill(lessee, data, payload)
    @lease_application.lease_application_blackbox_requests.create(
      request_control: @options[:request_control],
      request_event_source: @options[:request_event_source],
      leadrouter_response: data, 
      leadrouter_request_body: payload, 
      leadrouter_lead_id: data["leadID"],
      lessee: lessee,
      blackbox_endpoint: ENV['BLACKBOX_FILL_URL'].split('/').last,
      reject_stage: safe_to_i(data['rejectStage'])
    )
  end


  def create_blackbox_for_finalize(lessee, data, payload)

    @lease_application.lease_application_blackbox_requests.create(
      request_control: @options[:request_control],
      request_event_source: @options[:request_event_source],
      leadrouter_response: data, 
      leadrouter_credit_score: data["creditScore"], 
      leadrouter_suggested_corrections: data["suggestedCorrections"], 
      leadrouter_request_body: payload, 
      leadrouter_lead_id: data["leadID"],
      lessee: lessee,
      blackbox_endpoint: ENV['BLACKBOX_FINALIZE_URL'].split('/').last,
      reject_stage: safe_to_i(data['rejectStage'])
    )

  end


  def email_for_blackbox_auto_reject(blackbox)
    return false unless EmailTemplate.blackbox_auto_reject.enable_template
    response_decision = blackbox.leadrouter_response.dig("decision")
    LesseeMailer.blackbox_auto_reject(recipient: ENV['SUPPORT_EMAIL'], app: @lease_application, datax_id: blackbox.id ,response: response_decision).deliver_later if response_decision == "REJECT"
  end

  def generate_adverse_reason_codes(blackbox, data)
    adverse_reason_codes = data&.dig("adverseReasonCodes").presence
    blackbox.lease_application_blackbox_adverse_reasons.create_codes(adverse_reason_codes) if adverse_reason_codes
  end

  def generate_error_details(blackbox, data)
    error_details = data&.dig("errorDetails").presence
    blackbox.lease_application_blackbox_errors.create_data(error_details) if error_details
  end

  def generate_employment_search(blackbox, data)
    current_employer = data&.dig("extraAttributes", "twn_raw_report", "DataxResponse", "TWNSelectSegment").presence
    past_employers = data&.dig("extraAttributes", "twn_raw_report", "DataxResponse", "TWNSelectSegment", "EmploymentHistory", "Employment").presence

    [current_employer, past_employers].flatten.compact.each do |data|
      blackbox.lease_application_blackbox_employment_searches.create_data_from_blackbox(data)
    end
  end

  def get_blackbox_model_detail(blackbox_model_id, score)
    BlackboxModelDetail.where(blackbox_model_id: blackbox_model_id).where('? > credit_score_greater_than AND ? <= credit_score_max', score, score).first
  end

  def blackbox_model
    BlackboxModel.where(default_model: true).first
  end

  def generate_lease_applicaton_recommened_blackbox_tier(blackbox_model_detail)
    begin
      application_blackbox_model_detail = blackbox_model_detail
      l = @lease_application.reload
      unless @lease_application&.colessee.nil?
        _lessee_score = l&.lessee&.lease_application_blackbox_requests&.last&.leadrouter_credit_score&.to_i 
        _colessee_score = l&.colessee&.lease_application_blackbox_requests&.last&.leadrouter_credit_score&.to_i
        scores = [_lessee_score, _colessee_score].compact.reject(&:zero?)
        average_scode = 0
        unless scores.blank?
          average_scode = (scores.sum.to_f / scores.size.to_f).round
        end
        application_blackbox_model_detail = get_blackbox_model_detail(blackbox_model.id, average_scode)
      end

      rbt = l&.lease_application_recommended_blackbox_tiers.last
      rbt.blackbox_model_detail_id = application_blackbox_model_detail&.id
      rbt.lessee_lease_application_blackbox_request_id = l&.lessee&.lease_application_blackbox_requests&.last&.id
      rbt.colessee_lease_application_blackbox_request_id = l&.colessee&.lease_application_blackbox_requests&.last&.id
      rbt.save
    rescue => exception
      @logger.info(exception.message)
      @logger.info(exception.backtrace)
    end
  end

  def generate_lessee_recommended_blackbox_tier(lessee, blackbox, blackbox_model_detail)
    unless blackbox_model_detail.nil?
      blackbox.create_lessee_recommended_blackbox_tier(blackbox_model_detail_id: blackbox_model_detail.id, lessee_id: lessee.id)
    end
  end


  def run_credit_report_job(lessee)
      RunCreditReportService.new(
        lessee_id: lessee.id,
        request_type: @request_type,
        credit_report_job_opts: { request_control: @options[:request_control], request_event_source: @options[:request_event_source] }
      ).run_lessee
  end


  def create_lease_application_blackbox_tlo_person_search_addresses(blackbox, address_list)
    return false unless address_list
    address_list.each do |address|
      frist_seen_day = address.dig('DateFirstSeen', 'Day').nil? ? 1 : address.dig('DateFirstSeen', 'Day').to_i
      last_seen_day = address.dig('DateLastSeen', 'Day').nil? ? 1 : address.dig('DateLastSeen', 'Day').to_i
      date_first_seen =  Date.new(address.dig('DateFirstSeen', 'Year').to_i, address.dig('DateFirstSeen', 'Month').to_i, frist_seen_day) rescue nil
      date_last_seen =  Date.new(address.dig('DateLastSeen', 'Year').to_i, address.dig('DateLastSeen', 'Month').to_i, last_seen_day) rescue nil
      blackbox.lease_application_blackbox_tlo_person_search_addresses.create(
        date_first_seen: date_first_seen,
        date_last_seen: date_last_seen,
        street_address_1: address.dig('Address', 'Line1'),
        city: address.dig('Address', 'City'),
        state: address.dig('Address', 'State'),
        zip_code: address.dig('Address', 'Zip'),
        county: address.dig('Address', 'County'),
        zip_plus_four: address.dig('Address', 'Zip4'),
        building_name: address.dig('Address', 'BuildingName'),
        description: address.dig('Address', 'Description'),
        subdivision_name: address.dig('Address', 'SubdivisionName')
      )
    end
  end


end

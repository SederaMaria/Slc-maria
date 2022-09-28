class CreditReportJob
  include Sidekiq::Worker
  sidekiq_options unique: :until_executing

  # https://github.com/mperham/sidekiq/issues/2372
  # You can only utilize required/optional arguments
  def perform(lessee_id, retried_credit_report_id, request_type = :new, request_control = nil, request_event_source = nil)
    @lessee_id = lessee_id
    @lessee    = Lessee.where(id: lessee_id).first
    @logger = Logger.new(STDOUT)
    @logger.info ("CreditReportJob - #{request_type}")
    @request_type = request_type
    @retried_credit_report_id = retried_credit_report_id
    @options = { request_control: request_control, request_event_source: request_event_source }
    if @lessee
      save_pdf_report_as_attachment
      set_lessee_highest_fico_score
      
      set_effective_date
      set_bankruptcies
      set_repossessions
      BlackboxJob.new.perform(lessee_id: lessee_id, request_control: @options[:request_control], request_event_source: @options[:request_event_source])
      # RunBlackboxService.new(lessee_id: lessee_id, fetch_type: :finalize).run_lessee
      set_recommended_credit_tier
      set_lease_application_recommended_credit_tier
      lessee_credit_report.record_errors = []
      lessee_credit_report.save
    else
      Rails.logger.info("CreditReportJob: record not found for Lessee #{lessee_id}")
    end
  rescue => e
    add_errors(e)
    lessee_credit_report.failed
    lessee_credit_report.sidekiq_retry_count += 1
    lessee_credit_report.save
    message = "CreditReportJob: Failed #{@lessee.id}: #{@lessee.name} reason - #{e} - #{e.message} - #{e.backtrace}"
    Rails.logger.info(message)
    @logger.info(message)
    @logger.info ("BALAS #{lessee_credit_report.id}")

    # Disable auto retry on failure
    if false
      CreditReportJob.perform_in(lessee_credit_report.sidekiq_retry_count.minutes, lessee_id, lessee_credit_report.id) unless lessee_credit_report.sidekiq_retry_count > 5
    end
    # raise
  end

  private

  def formatted_timestamp
    Time.zone.now.in_time_zone('Eastern Time (US & Canada)').strftime('%B %-d %Y at %r %Z')
  end

  def credit_info
    @credit_info ||= Credco::Client.new(lessee_record: @lessee).credit_report
    if @credit_info
      credit_info_hash = Hash.from_xml(@credit_info&.gsub("\n", ""))
      borrower_id_score = nil
      revolving_credit_available = nil
      open_auto_monthly_payment = nil
      credit_score_hash = credit_info_hash.dig("RESPONSE_GROUP", "RESPONSE", "RESPONSE_DATA", "CREDIT_RESPONSE", "CREDIT_SCORE")
      credit_summary_hash = credit_info_hash.dig("RESPONSE_GROUP", "RESPONSE", "RESPONSE_DATA", "CREDIT_RESPONSE", "CREDIT_SUMMARY")

      credco_summary = credit_summary_hash&.select{ |n| n["_Name"] == "CREDCO_SUMMARY" }.first
      credco_exec_summary = credit_summary_hash&.select{ |n| n["_Name"] == "CREDCO_EXECUTIVE_SUMMARY" }.first
      
      unless credco_summary.nil?
        unless credco_summary.dig("_DATA_SET").nil?
          revolving_credit_available = credco_summary.dig("_DATA_SET").select{ |data| data["_Name"] == "_PrcntRevolvingCreditAvailable" }&.first["_Value"]
        end
      end

      unless credco_exec_summary.nil?
        unless credco_exec_summary.dig("_DATA_SET").nil?
          open_auto_monthly_payment = credco_exec_summary.dig("_DATA_SET").select{ |data| data["_Name"] == "Auto Loan Information: _TotalMonthlyPaymentOfOpenAccounts" }&.first["_Value"] 
        end
      end

      unless credit_score_hash.nil?
        @logger.info("credit_score_hash -")
        @logger.info(credit_score_hash)
        unless (credit_score_hash.fourth.nil? rescue true)
          borrower_id_score = credit_score_hash.fourth["_Value"]
        end
      end
      @lessee&.lease_application.create_lease_application_credco(
        borrower_id_score: borrower_id_score, 
        revolving_credit_available: revolving_credit_available,
        open_auto_monthly_payment: open_auto_monthly_payment
        ) if @lessee&.lease_application&.lease_application_credco.nil?
      return Credco::ResponseParser.new(credco_response: @credit_info)
    else
      message = "CreditReportJob: Failed pulling credit report for Lessee #{@lessee.id}: #{@lessee.name}"
      Rails.logger.info(message)
      raise(message)
    end
  end

  def save_pdf_report_as_attachment
    if credit_report_available?
      lessee_credit_report.update({
                                               upload:             pdf_report,
                                               visible_to_dealers: false,
                                               identifier:         credit_report_identifier
                                             })
      lessee_credit_report.succeeded!
    else
      message = "CreditReportJob: Failed pulling credit report for Lessee #{@lessee.id}: #{@lessee.name}"
      Rails.logger.info(message)
      raise(message)
    end
  end

  def credit_report_available?
    reusable_credit_report || credco_parser.has_embedded_file?
  end

  def set_lessee_highest_fico_score
    if credit_report_available?
      # using the same object (@lessee) here causes Rails to update the lease_application.lessee_id column to the same as colessee_id
      lessee                    = Lessee.find(@lessee_id)
      lessee.highest_fico_score = highest_fico_score
      lessee.save
    else
      Rails.logger.info("CreditReportJob: failed on #set_lessee_highest_fico_score for Lessee #{@lessee.id}: #{@lessee.name}")
    end
  end

  def highest_fico_score
    if reusable_credit_report
      reusable_credit_report&.lessee&.highest_fico_score
    else
      credco_parser.highest_fico_score
    end
  end

  def avg_credit_score
    if reusable_credit_report
      reusable_credit_report&.credit_score_average
    else
      calculate_average
    end
  end

  def pdf_report
    if reusable_credit_report
      reusable_credit_report&.upload
    else
      credco_parser.generate_credit_report_pdf
    end
  end

  def credit_report_identifier
    if reusable_credit_report
      reusable_credit_report&.identifier
    else
      credco_parser.credit_report_identifier
    end
  end

  def credco_parser
    @credco_parser ||= credit_info
  end

  def lessee_credit_report
    # past_unsuccessful_reports = @lessee.credit_reports.merge(CreditReport.unsuccessful)
    # @lessee_credit_report     ||= if past_unsuccessful_reports.any?
    #                                 past_unsuccessful_reports.last
    #                               else
    #                                 @lessee.credit_reports.create
    #                               end
    @lessee_credit_report     ||= if @retried_credit_report_id.nil?
                                    @lessee.credit_reports.create(credco_request_control: @options[:request_control], credco_request_event_source: @options[:request_event_source])
                                  else
                                    CreditReport.find(@retried_credit_report_id)
                                  end
  end

  def add_errors(e)
    unless lessee_credit_report.record_errors.include?(e.to_s)
      lessee_credit_report.record_errors << e
      # For `CreditReport.record_errors_v2`
      lessee_credit_report.record_errors << { message: e.message, backtrace: e.backtrace, timestamp: DateTime.now } if e.respond_to?(:message) && e.respond_to?(:backtrace)
    end
  end

  def reusable_credit_report
    return nil if @request_type == :repull
    results = LeaseApplication.where('created_at > ?', 30.days.ago).by_lessee_ssn(@lessee.ssn)
    results -= [@lessee.lease_application]
    if results.any?
      most_recent_application = results.last
      lessee_object           = most_recent_application.lessee if most_recent_application.lessee&.ssn == @lessee.ssn
      lessee_object           = most_recent_application.colessee if most_recent_application.colessee&.ssn == @lessee.ssn
      return lessee_object&.last_successful_credit_report
    else
      nil
    end
  end
  
  def set_effective_date
    reports = @lessee.credit_reports.select{ |report| report&.end_date&.to_date == "12/31/2999".to_date}
    reports.each do |report| 
      report.end_date = Time.now
      report.save
    end
    lessee_credit_report.credit_score = highest_fico_score
    lessee_credit_report.effective_date = Time.now
    lessee_credit_report.end_date =  "12/31/2999".to_datetime
    lessee_credit_report.credit_score_equifax = credco_parser.credit_score_equifax
    lessee_credit_report.credit_score_experian = credco_parser.credit_score_experian
    lessee_credit_report.credit_score_transunion = credco_parser.credit_score_transunion
    lessee_credit_report.credit_score_average = calculate_average
    lessee_credit_report.credco_xml = @credit_info.to_s.encode('UTF-8', credco_parser.xml_response.encoding, invalid: :replace, undef: :replace, replace: '')
    lessee_credit_report.save
  end

  def set_bankruptcies
    if credco_parser&.credit_public_record_bankruptcies&.present?
      credco_parser.credit_public_record_bankruptcies.each do |node|
        date_filed = parse_date(node['_FiledDate'])
        date_status = parse_date(node['_DispositionDate'])

        lessee_credit_report.credit_report_bankruptcies.create(
          date_filed: date_filed[:formatted],
          year_filed: date_filed[:year],
          month_filed: date_filed[:month],
          bankruptcy_type: node['_Type'],
          bankruptcy_status: node['_DispositionType'],
          date_status: date_status[:formatted]
        )
      end
    end
  end

  def set_repossessions
    if credco_parser&.credit_liability_repossessions&.present?
      credco_parser.credit_liability_repossessions.each do |node|
        date_filed = parse_date(node.at('_HIGHEST_ADVERSE_RATING/@_Date')&.value)

        lessee_credit_report.credit_report_repossessions.create(
          date_filed: date_filed[:formatted],
          year_filed: date_filed[:year],
          month_filed: date_filed[:month],
          creditor: node.at('_CREDITOR/@_Name')&.value,
          notes: node.at_xpath('CREDIT_COMMENT[2]/_Text/text()').to_s&.split('Derogatory FootNote')&.last,
        )
      end
    end
  end

  def calculate_average
    scores = []
    value = nil
    scores << credco_parser.credit_score_equifax << credco_parser.credit_score_experian << credco_parser.credit_score_transunion
    non_zero_scores = scores.compact.reject(&:zero?)
    unless non_zero_scores.blank?
      value = (non_zero_scores.sum.to_f / non_zero_scores.size.to_f).round
    end
    value
  end

  def colessee_average_score(colessee)
    scores = []
    value = nil
    credit_report = colessee&.last_successful_credit_report
    return 0 unless credit_report.present?
    scores << credit_report.credit_score_equifax << credit_report.credit_score_experian << credit_report.credit_score_transunion
    non_zero_scores = scores.reject{|x| x == 0 }
    unless non_zero_scores.blank?
      value = (non_zero_scores.sum.to_f / non_zero_scores.size.to_f).round(2)
    end
    value
  end

  def set_recommended_credit_tier
    recommended_credit_tier = LeaseApplication.credit_tier_range(credit_score&.round)
    credit_tier = CreditTier.all.select{|c| c.description.split(' ')[1].to_i == recommended_credit_tier }.first
    @lessee.recommended_credit_tiers.create(credit_report_id: lessee_credit_report.id, credit_tier_id: credit_tier&.id)
  end

  def credit_score
    datax = @lessee.lease_application.lease_application_blackbox_requests&.last&.leadrouter_response
    return 0 unless datax.present?
    decision = datax['decision']
    credit_score = datax['creditScore']
    if decision == 'ACCEPT' && credit_score.present?
      return credit_score
    elsif decision == 'REJECT' || !credit_score.present?
      lessee_credit_score = @lessee.last_successful_credit_report.credit_score
      app = @lessee.lease_application
      colessee = app&.colessee&.id == @lessee.id ? app&.lessee : app&.colessee
      colessee_avg_credit_score = colessee_average_score(colessee)
      if colessee_avg_credit_score.present? && colessee_avg_credit_score > 0
        avg = (avg_credit_score.to_f + colessee_avg_credit_score) / 2
        return avg
      else
        return avg_credit_score
      end
    end
  end

  def call_datax(lessee_id)
    #Datax::Client.new(lease_application_id: @lessee.lease_application.id).call if lessee_id == @lessee&.lease_application&.lessee_id
  end


  def set_lease_application_recommended_credit_tier

    begin
      rct = @lessee&.lease_application&.lease_application_recommended_credit_tiers&.last
      rct.credit_tier_id = get_credit_tier(credit_score_combined)&.id
      l = @lessee.reload&.lease_application
      rct.lessee_credit_report_id = l&.lessee&.credit_reports&.last&.id
      rct.colessee_credit_report_id = l&.colessee&.credit_reports&.last&.id
      rct.save
    rescue => exception
      @logger.info(exception.message)
      @logger.info(exception.backtrace)
    end
  
  end
  
  # def get_current_lessee_credit_report(lessee)
  #   lessee_credit_report if lessee&.id&.to_i == @lessee_id&.to_i
  # end

  def get_credit_tier(score)
    recommended_credit_tier = LeaseApplication.credit_tier_range(score&.round)
    CreditTier.all.select{|c| c.description.split(' ')[1].to_i == recommended_credit_tier }.first
  end

  def credit_score_combined
    scores = []
    value = nil
    scores << credco_parser.credit_score_equifax << credco_parser.credit_score_experian << credco_parser.credit_score_transunion
    colessee = get_colessee
    if colessee.present?
      colessee_credit_report = colessee&.last_successful_credit_report
      if  colessee_credit_report.present?
        scores << colessee_credit_report.credit_score_equifax << colessee_credit_report.credit_score_experian << colessee_credit_report.credit_score_transunion
      end
    end
    non_zero_scores = scores.compact.reject(&:zero?)
    unless non_zero_scores.blank?
      value = (non_zero_scores.sum.to_f / non_zero_scores.size.to_f).round
    end
    value
  end

  def get_colessee
    return @lessee&.lease_application&.lessee if @lessee.id == @lessee&.lease_application&.colessee&.id
    @lessee&.lease_application&.colessee
  end

  # @param [String] date_str Expecting a "YYYY-MM-DD" format
  def parse_date(date_str)
    data = date_str&.split("-") || []

    {
      year: data[0],
      month: data[1],
      day: data[2],
      formatted: data[0] && data[1] ? "#{Date::ABBR_MONTHNAMES[data[1].to_i]}-#{data[0]}" : nil
    }
  end
end

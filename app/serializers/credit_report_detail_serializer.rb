class CreditReportDetailSerializer < ApplicationSerializer
  attributes :id, :lessee, :status, :average_score, :actions, :requested_at, :updated_at, :bankruptcies, :repossessions,
             :record_errors, :record_errors_v2, :request_control, :request_event_source

  def lessee
    object&.lessee&.full_name
  end

  def average_score
    object&.credit_score_average || "N/A"
  end

  def actions
    object&.upload&.url
  end

  def requested_at
    object&.created_at&.strftime('%B %-d %Y at %r %Z')
  end

  def updated_at
    object&.updated_at&.strftime('%B %-d %Y at %r %Z')
  end

  def bankruptcies
    object&.credit_report_bankruptcies&.map do |record|
      CreditReportBankruptcySerializer.new(record)
    end || []
  end

  def repossessions
    object&.credit_report_repossessions&.map do |record|
      CreditReportRepossessionSerializer.new(record)
    end || []
  end

  def request_control
    object&.credco_request_control&.titleize
  end

  def request_event_source
    object&.credco_request_event_source
  end

  def record_errors
    object&.record_errors_v1
  end

  def record_errors_v2
    object&.record_errors_v2
  end
end

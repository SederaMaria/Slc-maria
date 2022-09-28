class LeaseApplicationDecorator < Draper::Decorator
  include LocalizedTimestamps
  decorates :lease_application
  delegate_all

  LeaseApplicationDecorator

  def funding_delay_on
    localize_date(attribute: __method__)
  end

  def funding_approved_on
    localize_date(attribute: __method__)
  end

  def funded_on
    localize_date(attribute: __method__)
  end

  def promotion_name
    object.promotion_name.blank? ? 'N/A' : object.promotion_name
  end

  def promotion_value
    object.promotion_value.blank? ? 'N/A' : object.promotion_value
  end

  def updated_at
    localize_timestamp(attribute: :updated_at)
  end

  def created_at
    localize_timestamp(attribute: :created_at)
  end

  def submitted_at
    localize_timestamp(attribute: :submitted_at) if object.submitted?
  end

  def stipulation_identifier
    names = []
    names.push(object.lessee.first_name) if has_lessee?
    names.push(object.colessee.first_name) if has_colessee?
    "- #{object.application_identifier} #{names.join(' ')}"
  end

  def has_lessee?
    object.lessee&.first_name.present?
  end

  def without_lessee?
    !has_lessee?
  end

  def has_colessee?
    object.colessee.present?
  end

  def without_colessee?
    !has_colessee?
  end

  def credit_reports
    CreditReport.where(lessee_id: [lessee_id, colessee_id].compact)
  end

  def model_and_year
    temp_year, temp_model = object.asset_year, object.asset_model
    if [temp_year, temp_model].any?(&:blank?)
      'Not Selected Yet'
    else
      "#{temp_year} #{temp_model}"
    end
  end

  def make
    object.lease_calculator&.asset_make
  end

  def credit_tier
    object.lease_calculator&.credit_tier_v2&.description
  end

  def application_identifier
    object.application_identifier.blank? ? 'N/A' : object.application_identifier
  end

  def days_submitted
    if expired?
      'Expired'
    elsif submitted_at.present?
      calculate_number_of_whole_twenty_four_hour_periods
    else
      ''
    end
  end

  def document_status
    object.document_status.titleize
  end

  def credit_status
    %w(draft unsubmitted).include?(object.credit_status) ? 'Saved - NOT Submitted' : object.credit_status.titleize
  end

  def can_change_bikes?
    object.no_documents? && approved_with_or_without_contingencies? && not_expired?
  end

  def approved_with_or_without_contingencies?
    object.approved? || object.approved_with_contingencies?
  end

  def can_request_lease_documents?
    can_change_bikes? #same logic for the time being
  end

  def all_checks_passed?
    lease_validations.blank? ? false : lease_validations.all? { |lv| lv.status_valid? }
  end

  def can_open_payment_calculator?
    object.unsubmitted? && object.no_documents? && not_expired?
  end

  def can_open_credit_application?
    object.unsubmitted? && not_expired?
  end

  def can_swap_applicants?
    no_documents? && not_expired? && has_colessee?
  end

  def can_add_coapplicant?
    no_documents? && not_expired? && !awaiting_credit_decision? && without_colessee?
  end

  def can_remove_coapplicant?
    no_documents? && not_expired? && ( unsubmitted? || approved? || approved_with_contingencies? || declined?) && has_colessee?
  end

  def can_send_credit_decision?
    approved? || approved_with_contingencies? || requires_additional_information? || declined? || rescinded? || withdrawn?
  end

  def not_expired?
    !expired?
  end

  def expired_warning
    h.content_tag :span, class: 'action_item' do
      h.content_tag :h3, class: 'expired' do
        'Expired'
      end
    end
  end

  def expiration_date
    if expired?
      h.content_tag :span, class: 'expired' do
        'Expired'
      end
    elsif submitted_at.present?
      object.submitted_at + 60.days
    else
      ''
    end
  end

  private

  def calculate_number_of_whole_twenty_four_hour_periods
    (Date.current - object.submitted_at).to_i
  end
end

# Mostly forked from `app/decorators/lease_application_decorator.rb`
class Api::DealersLeaseApplicationDecorator < Draper::Decorator
  decorates :lease_application
  delegate_all

  def can_open_payment_calculator?
    (object.awaiting_credit_decision? && object.no_documents? && not_expired? || object.declined? && object.no_documents? || object.documents_requested? && approved_with_or_without_contingencies? || object.documents_issued? && approved_with_or_without_contingencies? || object.lease_package_received? && approved_with_or_without_contingencies? || object.funding_delay? && approved_with_or_without_contingencies? || object.funding_approved? && approved_with_or_without_contingencies? || object.funded? && approved_with_or_without_contingencies? || object.canceled? && approved_with_or_without_contingencies?)
  end
  
  def can_edit_payment_calculator?
    (object.unsubmitted? && object.no_documents? && not_expired? || object.no_documents? && approved_with_or_without_contingencies?) 
  end

  def can_change_bikes?
    (object.no_documents? && approved_with_or_without_contingencies? && not_expired?)
  end

  def can_open_credit_application?
    (object.no_documents? && approved_with_or_without_contingencies? || object.awaiting_credit_decision? && object.no_documents? || object.documents_requested? && approved_with_or_without_contingencies? || object.documents_issued? && approved_with_or_without_contingencies? || object.lease_package_received? && approved_with_or_without_contingencies? || object.funding_delay? && approved_with_or_without_contingencies? || object.funding_approved? && approved_with_or_without_contingencies? || object.funded? && approved_with_or_without_contingencies? || object.canceled? && approved_with_or_without_contingencies?)
  end

  def can_edit_credit_application?
    object.unsubmitted? && object.no_documents?
  end

  def can_swap_applicants?
    no_documents? && not_expired? && has_colessee?
  end

  def can_add_coapplicant?
    no_documents? && not_expired? && !awaiting_credit_decision? && without_colessee?
  end

  def can_request_lease_documents?
    can_change_bikes? # Same logic for the time being
  end

  def can_remove_coapplicant?
    no_documents? && not_expired? && ( unsubmitted? || approved? || approved_with_contingencies? || declined?) && has_colessee?
  end

  def can_submit_bank_info?
  #   LeaseApplication.aasm(:document_status).states.map(&:name).select do |s|
  #     [:documents_requested, :documents_issued, :lease_package_received, :funding_delay, :funding_approved, :funded].include?(s)
  #   end.include?(object.document_status&.parameterize&.underscore&.to_sym)
  end

  private

  def not_expired?
    !expired?
  end

  def approved_with_or_without_contingencies?
    object.approved? || object.approved_with_contingencies?
  end

  def has_colessee?
    object.colessee&.first_name.present?
  end

  def without_colessee?
    !has_colessee?
  end
end
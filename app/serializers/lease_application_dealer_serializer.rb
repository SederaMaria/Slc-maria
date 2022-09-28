# == Schema Information
#
# Table name: lease_applications
#
#  id                                         :integer          not null, primary key
#  lessee_id                                  :integer
#  colessee_id                                :integer
#  dealer_id                                  :integer
#  lease_calculator_id                        :integer
#  created_at                                 :datetime         not null
#  updated_at                                 :datetime         not null
#  document_status                            :string           default("no_documents"), not null
#  credit_status                              :string           default("unsubmitted"), not null
#  submitted_at                               :date
#  expired                                    :boolean          default(FALSE)
#  application_identifier                     :string
#  documents_issued_date                      :date
#  dealership_id                              :integer
#  lease_package_received_date                :datetime
#  credit_decision_date                       :datetime
#  funding_delay_on                           :date
#  funding_approved_on                        :date
#  funded_on                                  :date
#  first_payment_date                         :date
#  payment_aba_routing_number                 :string
#  payment_account_number                     :string
#  payment_bank_name                          :string
#  payment_account_type                       :integer          default(NULL)
#  payment_frequency                          :integer
#  payment_first_day                          :integer
#  payment_second_day                         :integer
#  second_payment_date                        :date
#  promotion_name                             :string
#  promotion_value                            :float
#  is_dealership_subject_to_clawback          :boolean          default(FALSE)
#  this_deal_dealership_clawback_amount       :decimal(30, 2)
#  after_this_deal_dealership_clawback_amount :decimal(30, 2)
#  city_id                                    :bigint(8)
#  vehicle_possession                         :string
#  payment_account_holder                     :string
#  welcome_call_due_date                      :datetime
#  department_id                              :bigint(8)
#  is_verification_call_completed             :boolean          default(FALSE)
#  is_exported_to_access_db                   :boolean          default(FALSE)
#  requested_by                               :integer
#  approved_by                                :integer
#  prenote_status                             :string
#  mail_carrier_id                            :bigint(8)
#  workflow_status_id                         :bigint(8)
#
# Indexes
#
#  index_lease_applications_on_application_identifier  (application_identifier) UNIQUE WHERE (application_identifier IS NOT NULL)
#  index_lease_applications_on_city_id                 (city_id)
#  index_lease_applications_on_colessee_id             (colessee_id)
#  index_lease_applications_on_dealer_id               (dealer_id)
#  index_lease_applications_on_dealership_id           (dealership_id)
#  index_lease_applications_on_department_id           (department_id)
#  index_lease_applications_on_lease_calculator_id     (lease_calculator_id)
#  index_lease_applications_on_lessee_id               (lessee_id)
#  index_lease_applications_on_mail_carrier_id         (mail_carrier_id)
#  index_lease_applications_on_workflow_status_id      (workflow_status_id)
#
# Foreign Keys
#
#  fk_rails_...  (city_id => cities.id)
#  fk_rails_...  (colessee_id => lessees.id)
#  fk_rails_...  (dealer_id => dealers.id)
#  fk_rails_...  (dealership_id => dealerships.id)
#  fk_rails_...  (department_id => departments.id)
#  fk_rails_...  (lease_calculator_id => lease_calculators.id)
#  fk_rails_...  (lessee_id => lessees.id)
#  fk_rails_...  (mail_carrier_id => mail_carriers.id)
#  fk_rails_...  (workflow_status_id => workflow_statuses.id)
#

class LeaseApplicationDealerSerializer < ApplicationSerializer
  attributes :id, :application_identifier, :applicant, :co_applicant, :model_and_year, :credit_status,
             :document_status, :days_submitted, :last_updated, :action_permission

  def document_status
    object.document_status.humanize.titlecase
  end

  def credit_status
    object.credit_status.humanize.titlecase
  end

  def applicant
    object&.lessee&.full_name
  end

  def co_applicant
    object&.colessee&.full_name
  end

  def model_and_year
    temp_year, temp_model = object.asset_year, object.asset_model
    if [temp_year, temp_model].any?(&:blank?)
      'Not Selected Yet'
    else
      "#{temp_year} #{temp_model}"
    end
  end

  def days_submitted
    if object.expired?
      'Expired'
    elsif object.submitted_at.present?
      calculate_number_of_whole_twenty_four_hour_periods
    else
      ''
    end
  end

  def last_updated
    object&.updated_at&.strftime('%b %d, %Y at %l:%M %p %Z')
  end

  # Decorated by `Api::DealersLeaseApplicationDecorator`
  def action_permission
    {
      can_open_payment_calculator: object&.can_open_payment_calculator?,
      can_change_bikes: object&.can_change_bikes?,
      can_open_credit_application: object&.can_open_credit_application?,
      submitted: object&.submitted?,
      can_swap_applicants: object&.can_swap_applicants?,
      can_add_coapplicant: object&.can_add_coapplicant?,
      expired: object&.expired?,
      can_request_lease_documents: object&.can_request_lease_documents?,
      can_remove_coapplicant: object&.can_remove_coapplicant?,
      can_submit_bank_info: object&.can_submit_bank_info?,
      can_archive: true,
      can_edit_credit_application: object&.can_edit_credit_application?,
      can_edit_payment_calculator: object&.can_edit_payment_calculator?,
    }
  end

  private

  def to_currency(val)
    ActionController::Base.helpers.number_to_currency(val)
  end

  def to_delimited(val)
    ActiveSupport::NumberHelper.number_to_delimited(val)
  end

  def calculate_number_of_whole_twenty_four_hour_periods
    (Date.current - object.submitted_at).to_i
  end
end

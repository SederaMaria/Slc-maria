# == Schema Information
#
# Table name: lease_application_blackbox_employment_searches
#
#  id                                    :bigint(8)        not null, primary key
#  lease_application_blackbox_request_id :bigint(8)
#  employer_name                         :string
#  employee_first_name                   :string
#  employee_last_name                    :string
#  employee_encrypted_ssn                :text
#  employment_status                     :string
#  employment_start_date                 :date
#  total_months_with_employer            :integer
#  termination_date                      :date
#  position_title                        :string
#  rate_of_pay_cents                     :integer
#  annualized_income_cents               :integer
#  pay_frequency                         :string
#  pay_period_frequency                  :string
#  average_hours_worked_per_pay_period   :integer
#  compensation_history                  :jsonb
#  created_at                            :datetime         not null
#  updated_at                            :datetime         not null
#  employee_middle_name                  :string
#
# Indexes
#
#  index_blackbox_employment_searches_on_blackbox_request_id  (lease_application_blackbox_request_id)
#
class LeaseApplicationBlackboxEmploymentSearchSerializer < ApplicationSerializer
  attributes :id, :employment_start_date, :termination_date, :employer_name, :position_title, :employment_status,
             :average_hours_worked_per_pay_period, :rate_of_pay, :pay_frequency, :pay_period_frequency, :full_name,
             :compensation_history

  def rate_of_pay
    object&.rate_of_pay&.format
  end

  def full_name
    "#{object&.employee_first_name} #{object&.employee_middle_name} #{object&.employee_last_name}".squish
  end

  def compensation_history
    object&.compensation_history.try(:[], "Compensation")
  end
end

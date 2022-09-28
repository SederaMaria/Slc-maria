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
FactoryBot.define do
  factory :lease_application_blackbox_employment_search do
    lease_application_blackbox_request

    employer_name { "COSTCO" }
    employee_first_name { "Sarah" }
    employee_middle_name { nil }
    employee_last_name { "Milford" }
    employee_encrypted_ssn { "676894321" }
    employment_status { "ACTIVE" }
    employment_start_date { "2014-04-13" }
    total_months_with_employer { 70 }
    termination_date { nil }
    position_title { Associate III }
    rate_of_pay_cents { 1607 }
    annualized_income_cents { 3898297 }
    pay_frequency { "HOURLY" }
    pay_period_frequency { "BIWEEKLY" }
    average_hours_worked_per_pay_period { 0 }
    compensation_history { nil }
  end
end

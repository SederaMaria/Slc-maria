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
class LeaseApplicationBlackboxEmploymentSearch < ApplicationRecord
  belongs_to :lease_application_blackbox_request

  crypt_keeper :employee_encrypted_ssn, encryptor: :postgres_pgp, key: ENV['SSN_ENCRYPTION_KEY'], salt: ENV['SSN_ENCRYPTION_SALT']

  monetize :rate_of_pay_cents, allow_nil: true
  monetize :annualized_income_cents, allow_nil: true

  # @data [Hash] Employment Data model from Blackbox response: TWNSelectSegment<Hash> and TWNSelectSegment/EmploymentHistory/Employment<Array>
  def self.create_data_from_blackbox(data)
    if data && data.is_a?(Hash) # Or do some json schema validation?

      self.create(
        employer_name: data["EmployerName"],
        employee_first_name: data["EmployeeFirstName"],
        employee_middle_name: data["EmployeeMiddleName"],
        employee_last_name: data["EmployeeLastName"],
        employee_encrypted_ssn: data["EmployeeSSN"],
        employment_status: data["EmploymentStatus"],
        employment_start_date: data["EmploymentStartDate"], # Recognizes YYYY-MM-DD
        total_months_with_employer: data["TotalMonthsWithEmployer"],
        termination_date: data["TerminationDate"], # Recognizes YYYY-MM-DD
        position_title: data["PositionTitle"],
        rate_of_pay: data["RateOfPay"],
        annualized_income: data["AnnualizedIncome"],
        pay_frequency: data["PayFrequency"],
        pay_period_frequency: data["PayPeriodFrequency"],
        average_hours_worked_per_pay_period: data["AverageHoursWorkedPerPayPeriod"],
        compensation_history: data["CompensationHistory"],
      )
    end
  end
end

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
require 'rails_helper'

RSpec.describe LeaseApplicationBlackboxEmploymentSearch, type: :model do
  it { should belong_to(:lease_application_blackbox_request) }

  it 'creates correctly' do
    record = create(:lease_application_blackbox_employment_search)
    expect(record).to be_valid
    expect(record).to be_persisted
  end
end

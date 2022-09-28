class CreateLeaseApplicationBlackboxEmploymentSearches < ActiveRecord::Migration[6.0]
  def change
    create_table :lease_application_blackbox_employment_searches do |t|
      t.references :lease_application_blackbox_request, index: { name: 'index_blackbox_employment_searches_on_blackbox_request_id' }

      t.string    :employer_name
      t.string    :employee_first_name
      t.string    :employee_last_name
      t.text      :employee_encrypted_ssn
      t.string    :employment_status
      t.date      :employment_start_date
      t.integer   :total_months_with_employer
      t.date      :termination_date
      t.string    :position_title
      t.integer   :rate_of_pay_cents
      t.integer   :annualized_income_cents
      t.string    :pay_frequency
      t.string    :pay_period_frequency
      t.integer   :average_hours_worked_per_pay_period
      t.jsonb     :compensation_history, default: {}

      t.timestamps
    end
  end
end

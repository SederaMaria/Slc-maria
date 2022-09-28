class AddMissingFieldsToLessees < ActiveRecord::Migration[5.0]
  def change
    add_column :lessees, :at_address_years, :integer
    add_column :lessees, :at_address_months, :integer
    add_column :lessees, :monthly_mortgage, :decimal, scale: 2, precision: 4
    add_column :lessees, :home_ownership, :integer, default: 0, index: true
    add_column :lessees, :drivers_licence_expires_at, :date
    add_column :lessees, :employer_name, :string
    add_column :lessees, :time_at_employer_years, :integer
    add_column :lessees, :time_at_employer_months, :integer
    add_column :lessees, :job_title, :string
    add_column :lessees, :employment_status, :integer, default: 0, index: true
    add_column :lessees, :employer_phone_number, :string
    add_column :lessees, :gross_monthly_income, :decimal, scale: 2, precision: 4
    add_column :lessees, :other_monthly_income, :decimal,scale: 2, precision: 4
  end
end

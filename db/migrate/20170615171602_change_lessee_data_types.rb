class ChangeLesseeDataTypes < ActiveRecord::Migration[5.0]
  def change
    #remove scale and precision, allow any values for now
    change_column :lessees, :monthly_mortgage, :decimal
    change_column :lessees, :gross_monthly_income, :decimal
    change_column :lessees, :other_monthly_income, :decimal
  end
end

#  monthly_mortgage           :decimal(4, 2)
#  home_ownership             :integer
#  drivers_licence_expires_at :date
#  employer_name              :string
#  time_at_employer_years     :integer
#  time_at_employer_months    :integer
#  job_title                  :string
#  employment_status          :integer
#  employer_phone_number      :string
#  gross_monthly_income       :decimal(4, 2)
#  other_monthly_income       :decimal(4, 2)

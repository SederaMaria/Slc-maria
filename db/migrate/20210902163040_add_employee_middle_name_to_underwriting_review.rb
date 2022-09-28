class AddEmployeeMiddleNameToUnderwritingReview < ActiveRecord::Migration[6.0]
  def change
    add_column :lease_application_blackbox_employment_searches, :employee_middle_name, :string
  end
end

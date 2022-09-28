class AddAssignedDepartmentIdToLeaseApplication < ActiveRecord::Migration[5.1]
  def change
    add_reference :lease_applications, :assigned_department, foreign_key: true
  end
end

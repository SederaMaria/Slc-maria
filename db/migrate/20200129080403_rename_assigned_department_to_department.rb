class RenameAssignedDepartmentToDepartment < ActiveRecord::Migration[5.1]
  def change
    rename_table :assigned_departments, :departments
    rename_column :lease_applications, :assigned_department_id, :department_id
  end
end

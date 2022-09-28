class CreateAssignedDepartments < ActiveRecord::Migration[5.1]
  def change
    create_table :assigned_departments do |t|
      t.boolean :active, default: true
      t.string :description
      
      t.timestamps
    end
  end
end

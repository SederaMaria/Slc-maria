class CreateEmploymentStatuses < ActiveRecord::Migration[5.1]
  def change
    create_table :employment_statuses do |t|
      t.integer :employment_status_index
      t.string :definition

      t.timestamps
    end
  end
end

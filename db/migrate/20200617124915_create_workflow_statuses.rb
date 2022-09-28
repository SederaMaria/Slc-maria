class CreateWorkflowStatuses < ActiveRecord::Migration[5.1]
  def change
    create_table :workflow_statuses do |t|
      t.string :description
      t.boolean :active, dafault: true
      t.timestamps
    end
  end
end

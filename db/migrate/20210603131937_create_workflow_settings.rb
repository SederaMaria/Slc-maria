class CreateWorkflowSettings < ActiveRecord::Migration[6.0]
  def change
    create_table :workflow_settings do |t|
      t.string :workflow_setting_name, unique: true
      t.references :workflow, foreign_key: true, index: true

      t.timestamps
    end
  end
end

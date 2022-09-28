class CreateWorkflowSettingValues < ActiveRecord::Migration[6.0]
  def change
    create_table :workflow_setting_values do |t|
      t.references :workflow_setting, foreign_key: true, index: true
      t.references :admin_user, foreign_key: true, index: true
      t.timestamps
    end
  end
end

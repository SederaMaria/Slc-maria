class ChangeColumnIsDisabledToIsActive < ActiveRecord::Migration[5.1]
  def change
  	rename_column :admin_users, :is_disabled, :is_active
  	change_column :admin_users, :is_active, :boolean, default: true
  end
end

class RemoveColumnUserIsActiveFromAdminUser < ActiveRecord::Migration[5.1]
  def change
  	remove_column :admin_users, :user_is_active
  end
end

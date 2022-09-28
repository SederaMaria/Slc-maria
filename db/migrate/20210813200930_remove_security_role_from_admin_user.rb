class RemoveSecurityRoleFromAdminUser < ActiveRecord::Migration[6.0]
  def change
    remove_column :admin_users, :security_role_id
  end
end

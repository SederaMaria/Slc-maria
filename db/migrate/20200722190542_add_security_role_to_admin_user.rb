class AddSecurityRoleToAdminUser < ActiveRecord::Migration[5.1]
  def change
    add_reference :admin_users, :security_role, foreign_key: true, index: true
  end
end

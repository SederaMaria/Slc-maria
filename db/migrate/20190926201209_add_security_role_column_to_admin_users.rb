class AddSecurityRoleColumnToAdminUsers < ActiveRecord::Migration[5.1]
  def change
  	 add_column :admin_users, :security_role, :string
  end
end

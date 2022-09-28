class AddTokenCreatedAtToAdminUsers < ActiveRecord::Migration[5.1]
  def change
	add_column :admin_users, :auth_token, :string
    add_column :admin_users, :auth_token_created_at, :datetime
    add_index :admin_users, [:auth_token, :auth_token_created_at]
  end
end

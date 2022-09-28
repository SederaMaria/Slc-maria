class AddLastRequestAtToAdminUser < ActiveRecord::Migration[5.1]
  def change
    add_column :admin_users, :last_request_at, :datetime
  end
end

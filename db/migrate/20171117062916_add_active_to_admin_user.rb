class AddActiveToAdminUser < ActiveRecord::Migration[5.1]
  def change
    add_column :admin_users, :is_disabled, :boolean, default: false
  end
end

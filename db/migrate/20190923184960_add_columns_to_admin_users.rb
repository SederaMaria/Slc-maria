class AddColumnsToAdminUsers < ActiveRecord::Migration[5.1]
  def change
  	add_column :admin_users, :job_title, :string
  	add_column :admin_users, :user_is_active, :boolean
  end

end

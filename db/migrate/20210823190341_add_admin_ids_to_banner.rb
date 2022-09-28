class AddAdminIdsToBanner < ActiveRecord::Migration[6.0]
  def change
    add_reference :banners, :created_by_admin, foreign_key: { to_table: :admin_users }
    add_reference :banners, :updated_by_admin, foreign_key: { to_table: :admin_users }
  end
end

class CreatePermissions < ActiveRecord::Migration[6.0]
  def change
    create_table :permissions do |t|
      t.references :security_role, foreign_key: true, index: true
      t.references :resource, null: false, foreign_key: true, index: true
      t.references :action, null: false, foreign_key: true, index: true   

      t.references :created_by_admin, foreign_key: { to_table: :admin_users }, index: { name: 'index_permissions_created_by_on_admin_user_id' }
      t.references :updated_by_admin, foreign_key: { to_table: :admin_users }, index: { name: 'index_permissions_updated_by_on_admin_user_id' }

      t.timestamps
    end
  end
end

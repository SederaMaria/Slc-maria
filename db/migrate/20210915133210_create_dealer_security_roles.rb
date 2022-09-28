class CreateDealerSecurityRoles < ActiveRecord::Migration[6.0]
  def change
    create_table :dealer_security_roles do |t|
      t.references :dealer, foreign_key: true, index: true
      t.references :security_role, foreign_key: true, index: true

      t.references :created_by_admin, foreign_key: { to_table: :admin_users },
                                      index: { name: 'index_dealer_security_roles_created_by_on_admin_user_id' }
      t.references :updated_by_admin, foreign_key: { to_table: :admin_users },
                                      index: { name: 'index_dealer_security_roles_updated_by_on_admin_user_id' }

      t.timestamps
    end
  end
end

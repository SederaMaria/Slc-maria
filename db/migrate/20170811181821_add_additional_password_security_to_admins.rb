class AddAdditionalPasswordSecurityToAdmins < ActiveRecord::Migration[5.0]
  def change
    change_table :admin_users do |t|
      t.datetime :password_changed_at
    end

    add_index :admin_users, :password_changed_at
    
    AdminUser.reset_column_information
    AdminUser.update_all(password_changed_at: 1.minute.ago)

    create_table :old_passwords do |t|
      t.string :encrypted_password, :null => false
      t.string :password_archivable_type, :null => false
      t.integer :password_archivable_id, :null => false
      t.datetime :created_at
    end
    add_index :old_passwords, [:password_archivable_type, :password_archivable_id], :name => :index_password_archivable

  end
end

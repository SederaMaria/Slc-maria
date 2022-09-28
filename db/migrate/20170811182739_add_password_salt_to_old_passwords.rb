class AddPasswordSaltToOldPasswords < ActiveRecord::Migration[5.0]
  def change
    add_column :old_passwords, :password_salt, :string
  end
end

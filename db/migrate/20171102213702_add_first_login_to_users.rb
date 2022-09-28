class AddFirstLoginToUsers < ActiveRecord::Migration[5.1]
  def change
    add_column :dealers, :first_sign_in_at, :datetime
  end
end

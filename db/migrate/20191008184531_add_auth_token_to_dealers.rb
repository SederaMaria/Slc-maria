class AddAuthTokenToDealers < ActiveRecord::Migration[5.1]
  def change
	add_column :dealers, :auth_token, :string, unique: true
    add_column :dealers, :auth_token_created_at, :datetime
    add_index  :dealers, [:auth_token, :auth_token_created_at]
  end
end

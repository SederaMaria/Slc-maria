class CreateApiTokens < ActiveRecord::Migration[6.0]
  def change
    create_table :api_tokens do |t|
      t.string :name
      t.string :access_token
      t.datetime :access_token_created_at

      t.timestamps
    end
    add_index :api_tokens, :access_token, unique: true
  end
end

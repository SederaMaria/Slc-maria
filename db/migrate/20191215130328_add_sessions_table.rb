class AddSessionsTable < ActiveRecord::Migration[5.1]
  def change
    create_table :sessions do |t|
      t.string :session_id, :null => false
      t.jsonb :data, :null => false
      t.timestamps
    end

    add_index :sessions, :session_id, :unique => true
    add_index :sessions, :updated_at
  end
end

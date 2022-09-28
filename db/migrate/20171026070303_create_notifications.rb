class CreateNotifications < ActiveRecord::Migration[5.1]
  def change
    create_table :notifications do |t|
      t.datetime :read_at
      t.integer :recipient_id, null: false
      t.string :recipient_type, null: false
      t.string :notification_mode, null: false
      t.string :notification_content, null: false
      t.jsonb :data, default: {}

      t.timestamps
    end
  end
end

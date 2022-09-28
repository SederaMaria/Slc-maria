class CreateNotificationAttachments < ActiveRecord::Migration[5.1]
  def change
    create_table :notification_attachments do |t|
      t.references :notification
      t.string :description
      t.string :upload

      t.timestamps
    end
  end
end

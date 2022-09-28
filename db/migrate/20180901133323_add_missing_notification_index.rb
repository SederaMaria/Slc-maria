class AddMissingNotificationIndex < ActiveRecord::Migration[5.1]
  def change
    #  recipient_id         :integer          not null
    #  recipient_type       :string           not null
    #  notification_mode    :string           not null

    add_index :notifications, [:recipient_id, :recipient_type], name: 'notifications_recipient_idx'
    add_index :notifications, [:recipient_id, :recipient_type, :notification_mode], name: 'notifications_recipient_and_mode_idx'

  end
end

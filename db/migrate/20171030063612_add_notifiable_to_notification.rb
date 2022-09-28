class AddNotifiableToNotification < ActiveRecord::Migration[5.1]
  def change
    add_column :notifications, :notifiable_id, :integer
    add_column :notifications, :notifiable_type, :string
  end
end

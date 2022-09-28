class AddApplicationNotifyEmailToDealership < ActiveRecord::Migration[6.0]
  def change
    add_column :dealerships, :notification_email, :string, limit: 255
  end
end

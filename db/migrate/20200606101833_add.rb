class Add < ActiveRecord::Migration[5.1]
  def change
    add_column :prenotes, :email_notification_sent, :boolean, default: false
  end
end

class AddTimestampsToInboundContacts < ActiveRecord::Migration[5.0]
  def change
    add_timestamps(:inbound_contacts, null: true)
    InboundContact.update_all(created_at: Time.zone.now, updated_at: Time.zone.now)
    change_column_null :inbound_contacts, :created_at, false
    change_column_null :inbound_contacts, :updated_at, false
  end
end

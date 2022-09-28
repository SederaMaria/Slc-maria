class AddFieldsToInboundContact < ActiveRecord::Migration[5.1]
  def change
    add_column :inbound_contacts, :account_number, :string
    add_column :inbound_contacts, :existing_user, :boolean
  end
end

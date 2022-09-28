class AddDealershipNameToInboundContact < ActiveRecord::Migration[5.0]
  def change
    add_column :inbound_contacts, :dealership_name, :string
  end
end

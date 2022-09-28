class AddKindToInboundContact < ActiveRecord::Migration[5.0]
  def change
    add_column :inbound_contacts, :kind, :integer
  end
end

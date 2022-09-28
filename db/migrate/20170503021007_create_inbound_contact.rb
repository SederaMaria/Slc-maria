class CreateInboundContact < ActiveRecord::Migration[5.0]
  def change
    create_table :inbound_contacts do |t|
      t.string :name, limit: 255
      t.string :email, limit: 255
      t.text :message
      t.timestamp
    end
  end
end

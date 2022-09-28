class AddPhoneNumberToInboudContact < ActiveRecord::Migration[5.0]
  def change
    add_column :inbound_contacts, :phone, :string
  end
end

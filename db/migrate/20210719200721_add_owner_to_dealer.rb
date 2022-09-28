class AddOwnerToDealer < ActiveRecord::Migration[6.0]
  def change
    add_column :dealerships, :owner_first_name, :string
    add_column :dealerships, :owner_last_name, :string
    add_reference :dealerships, :owner_address, foreign_key: { to_table: :addresses }, index: { name: 'index_dealerships_ownership_address_id_on_address_id' }
    add_column :dealerships, :business_description, :string
  end
end

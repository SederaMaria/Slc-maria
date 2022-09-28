class AddUniqueIndexToRoutingNumberTable < ActiveRecord::Migration[5.0]
  def change
    add_index :bank_routing_numbers, :routing_number, unique: true
  end
end

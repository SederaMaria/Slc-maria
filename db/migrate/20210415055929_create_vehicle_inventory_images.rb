class CreateVehicleInventoryImages < ActiveRecord::Migration[6.0]
  def change
    create_table :vehicle_inventory_images do |t|
      t.string :image
      t.references :vehicle_inventory, foreign_key: true, index: true

      t.timestamps
    end
  end
end

class CreateVehicleInventories < ActiveRecord::Migration[6.0]
  def change
    create_table :vehicle_inventories do |t|

      t.string  :asset_make
      t.string  :asset_model
      t.integer :asset_year
      t.string  :asset_vin
      t.string  :asset_color
      t.string  :exact_odometer_mileage
      t.string  :new_used
      t.string :stock_number
      t.datetime :intake_date
      t.datetime :sale_date
      t.references :inventory_status, foreign_key: true

      t.timestamps
    end
  end
end

class CreateMakes < ActiveRecord::Migration[5.0]
  def change
    create_table :makes do |t|
      t.string :name
      t.string :vin_starts_with
      t.timestamps
    end
  end
end

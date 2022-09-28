class CreateMileageTiers < ActiveRecord::Migration[5.0]
  def change
    create_table :mileage_tiers do |t|
      t.integer :upper
      t.integer :lower

      t.timestamps
    end
  end
end

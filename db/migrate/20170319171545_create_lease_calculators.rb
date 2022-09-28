class CreateLeaseCalculators < ActiveRecord::Migration[5.0]
  def change
    create_table :lease_calculators do |t|
      t.string :asset_make
      t.string :asset_model
      t.integer :asset_year
      t.integer :condition
      t.string :mileage_tier
      t.string :credit_tier
      t.integer :term
      t.string :tax_jurisdiction
      t.string :us_state
      t.timestamps
    end
  end
end

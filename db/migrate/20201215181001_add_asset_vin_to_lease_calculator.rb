class AddAssetVinToLeaseCalculator < ActiveRecord::Migration[6.0]
  def change
    add_column :lease_calculators, :asset_vin, :string
  end
end

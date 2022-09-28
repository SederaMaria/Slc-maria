class AddGpsCentsToLeaseCalculators < ActiveRecord::Migration[6.0]
  def change
    add_column :lease_calculators, :gps_cost_cents, :integer, default: 0, null: false
  end
end

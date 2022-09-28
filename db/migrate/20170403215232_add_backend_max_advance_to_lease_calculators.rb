class AddBackendMaxAdvanceToLeaseCalculators < ActiveRecord::Migration[5.0]
  def change
    add_monetize :lease_calculators, :backend_max_advance
  end
end

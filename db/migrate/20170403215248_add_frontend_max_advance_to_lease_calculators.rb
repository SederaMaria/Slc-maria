class AddFrontendMaxAdvanceToLeaseCalculators < ActiveRecord::Migration[5.0]
  def change
    add_monetize :lease_calculators, :frontend_max_advance
  end
end

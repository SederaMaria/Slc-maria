class AddCreditTierIdToLeaseCalculator < ActiveRecord::Migration[5.1]
  def change
    add_reference :lease_calculators, :credit_tier, foreign_key: true
  end
end

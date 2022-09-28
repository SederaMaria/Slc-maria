class AddOriginalMsrpToLeaseCalculators < ActiveRecord::Migration[5.1]
  def change
    add_monetize :lease_calculators, :original_msrp
  end
end

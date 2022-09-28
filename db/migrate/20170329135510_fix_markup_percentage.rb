class FixMarkupPercentage < ActiveRecord::Migration[5.0]
  def up
    LeaseCalculator.update_all(:dealer_participation_markup_percentage_cents => 0)
    change_column :lease_calculators, :dealer_participation_markup_percentage_cents, :decimal, scale: 2, precision: 3, default: 0.00
  end
end

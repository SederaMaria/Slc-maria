class AddShortfundToLeaseCalculator < ActiveRecord::Migration[5.1]
  def change
    add_column :lease_calculators, :dealer_shortfund_amount_cents, :integer, default: 0, null: false
    add_column :lease_calculators, :remit_to_dealer_less_shortfund_cents, :integer, default: 0, null: false
  end
end

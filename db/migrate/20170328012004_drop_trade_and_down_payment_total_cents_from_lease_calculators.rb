class DropTradeAndDownPaymentTotalCentsFromLeaseCalculators < ActiveRecord::Migration[5.0]
  def up
    remove_column :lease_calculators, :trade_and_down_payment_total_cents
  end

  def down
    raise 'Cant go backwards'
  end
end

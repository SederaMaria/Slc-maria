class AddPreTaxPaymentsSumToLeaseCalculator < ActiveRecord::Migration[5.1]
  def change
    add_column :lease_calculators, :pre_tax_payments_sum_cents, :integer, default: 0, null: false
  end
end

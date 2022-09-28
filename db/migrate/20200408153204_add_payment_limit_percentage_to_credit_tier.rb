class AddPaymentLimitPercentageToCreditTier < ActiveRecord::Migration[5.1]
  def change
    add_column :credit_tiers, :payment_limit_percentage, :decimal, default: 0, precision: 4, scale: 2
  end
end

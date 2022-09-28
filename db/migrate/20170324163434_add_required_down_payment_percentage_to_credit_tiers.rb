class AddRequiredDownPaymentPercentageToCreditTiers < ActiveRecord::Migration[5.0]
  def change
    add_column :credit_tiers, :required_down_payment_percentage, :decimal, default: 0, precision: 4, scale: 2
  end
end

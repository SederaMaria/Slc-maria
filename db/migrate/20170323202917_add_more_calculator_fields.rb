class AddMoreCalculatorFields < ActiveRecord::Migration[5.0]
  def change
    change_table :lease_calculators do |t|
      t.monetize :gross_trade_in_allowance
      t.monetize :trade_in_payoff
      t.monetize :net_trade_in_allowance
      t.monetize :rebates_and_noncash_credits
      t.monetize :cash_down_payment
      t.monetize :cash_down_minimum
      t.monetize :total_capitalized_cost_reduction
      t.monetize :net_due_on_motorcycle
      t.monetize :aquisition_fee
      t.monetize :adjusted_capitalized_cost
      t.monetize :gross_capitalized_cost
      t.monetize :base_monthly_payment
      t.monetize :monthly_sales_tax
      t.monetize :total_monthly_payment
      t.monetize :refundable_security_deposit
      t.monetize :total_cash_at_signing
      t.monetize :minimum_reserve
      t.monetize :dealer_participation_markup_percentage
      t.monetize :dealer_reserve
      t.monetize :monthly_depreciation_charge
      t.monetize :monthly_lease_charge
      t.monetize :trade_and_down_payment_total
      t.monetize :cod_on_lease
      t.monetize :remit_to_dealer
    end
  end
end

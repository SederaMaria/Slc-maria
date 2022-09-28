class ResaveAdjustedCapitalizedCosts < ActiveRecord::Migration[5.0]
  def up    
    LeaseCalculator.submittable.find_each do |lc|
      puts("Processing LeaseCalculator ID: #{lc.id}...")
      calculated_cap_cost = lc.total_dealer_price + 
        lc.upfront_tax + 
        lc.title_license_and_lien_fee +
        lc.dealer_documentation_fee +
        lc.guaranteed_auto_protection_cost + 
        lc.prepaid_maintenance_cost + 
        lc.extended_service_contract_cost +
        lc.tire_and_wheel_contract_cost +
        lc.acquisition_fee - 
        lc.net_trade_in_allowance - 
        lc.cash_down_payment
      puts("...Calculated New Adjusted Cap Cost: #{calculated_cap_cost}")
      lc.update_attribute(:adjusted_capitalized_cost, calculated_cap_cost)
    end
  end

  def down
    LeaseCalculator.update_all(adjusted_capitalized_cost_cents: 0)
  end
end

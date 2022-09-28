class AddMoneyFieldsToLeaseCalculators < ActiveRecord::Migration[5.0]
  def change
    change_table :lease_calculators do |t|
      t.monetize :nada_retail_value
      t.monetize :customer_purchase_option
      t.monetize :dealer_sales_price
      t.monetize :dealer_freight_and_setup
      t.monetize :total_dealer_price
      t.monetize :upfront_tax
      t.monetize :title_license_and_lien_fee
      t.monetize :dealer_documentation_fee
      t.monetize :guaranteed_auto_protection_cost
      t.monetize :prepaid_maintenance_cost
      t.monetize :extended_service_contract_cost
      t.monetize :tire_and_wheel_contract_cost
      t.monetize :fi_maximum_total
      t.monetize :total_sales_price
    end
  end
end

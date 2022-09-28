class CreateTaxRules < ActiveRecord::Migration[5.0]
  def change
    create_table :tax_rules do |t|
      t.string :name 
      t.decimal :sales_tax_percentage, precision: 9, scale: 8
      t.decimal :up_front_tax_percentage, precision: 9, scale: 8
      t.decimal :cash_down_tax_percentage, precision: 9, scale: 8
      t.boolean :tax_down_payment, default: false
      t.boolean :tax_sales_price, default: false
      t.boolean :tax_title_fees, default: false
      t.boolean :tax_document_fee, default: false
      t.boolean :tax_acquisition_fee, default: false
      t.boolean :tax_gap_contract_fee, default: false
      t.boolean :tax_prepaid_maintenence_contract_fee, default: false
      t.boolean :tax_service_contract_fee, default: false
      t.boolean :tax_dealer_freight_fee, default: false
      t.string :tax_methodology 
      t.integer :rule_type
      t.timestamps
    end
  end
end

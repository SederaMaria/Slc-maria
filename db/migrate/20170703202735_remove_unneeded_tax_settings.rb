class RemoveUnneededTaxSettings < ActiveRecord::Migration[5.0]
  def change
    remove_columns :tax_rules, 
      :tax_sales_price, 
      :tax_title_fees, 
      :tax_down_payment, 
      :tax_document_fee, 
      :tax_acquisition_fee, 
      :tax_gap_contract_fee,
      :tax_prepaid_maintenence_contract_fee,
      :tax_service_contract_fee,
      :tax_dealer_freight_fee

    remove_column :model_years, :subvention_cents
  end
end

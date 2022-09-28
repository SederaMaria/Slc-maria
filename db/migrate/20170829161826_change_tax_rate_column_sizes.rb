class ChangeTaxRateColumnSizes < ActiveRecord::Migration[5.0]
  def change
    change_column :tax_rules, :sales_tax_percentage, :decimal, precision: 6, scale: 4
    change_column :tax_rules, :up_front_tax_percentage, :decimal, precision: 6, scale: 4
    change_column :tax_rules, :cash_down_tax_percentage, :decimal, precision: 6, scale: 4
  end
end

#sales_tax_percentage     :decimal(9, 8)    default(0.0)
#  up_front_tax_percentage  :decimal(9, 8)    default(0.0)
#  cash_down_tax_percentage

class DropTaxMethodologyFromTaxRules < ActiveRecord::Migration[5.0]
  def change
    remove_column :tax_rules, :tax_methodology
  end
end

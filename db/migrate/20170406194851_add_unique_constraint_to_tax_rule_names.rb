class AddUniqueConstraintToTaxRuleNames < ActiveRecord::Migration[5.0]
  def change
    add_index :tax_rules, :name, unique: true
  end
end

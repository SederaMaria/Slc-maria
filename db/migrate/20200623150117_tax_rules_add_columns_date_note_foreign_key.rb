class TaxRulesAddColumnsDateNoteForeignKey < ActiveRecord::Migration[5.1]
  def change
  	add_reference :tax_rules, :tax_jurisdictions, foreign_key: true

  	add_column :tax_rules, :end_date, :date, default: "2999-12-31"

  	add_column :tax_rules, :notes, :string, limit: 100
  end
end

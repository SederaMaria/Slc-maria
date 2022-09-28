class AddAttributesToTaxRules < ActiveRecord::Migration[5.1]
  def change
    add_column :tax_rules, :geocode_state, :string, limit: 2
    add_column :tax_rules, :geocode_county, :string, limit: 3
    add_column :tax_rules, :geocode_city, :string, limit: 4
    add_column :tax_rules, :geo_code, :string, limit: 9
    add_column :tax_rules, :effective_date, :date
    add_column :tax_rules, :prior_rate, :decimal
  end
end

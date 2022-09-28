class TaxRulesDropGeocodeColumns < ActiveRecord::Migration[5.1]
  def change
  	remove_column :tax_rules, :geocode_state
  	remove_column :tax_rules, :geocode_county
  	remove_column :tax_rules, :geocode_city
  	remove_column :tax_rules, :geo_code
  end
end

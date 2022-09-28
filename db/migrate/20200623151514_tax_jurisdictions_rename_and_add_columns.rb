class TaxJurisdictionsRenameAndAddColumns < ActiveRecord::Migration[5.1]
  def change
  	add_reference :tax_jurisdictions, :tax_record_types, foreign_key: true

  	add_column :tax_jurisdictions, :jurisdiction_name, :string, limit: 100
  	add_column :tax_jurisdictions, :zip_code_start, :string, limit: 10
  	add_column :tax_jurisdictions, :zip_code_end, :string, limit: 10
  	add_column :tax_jurisdictions, :ignore_sales_tax_engine, :boolean, default: false

  	rename_column :tax_jurisdictions, :geo_state, :geo_code_state
  	rename_column :tax_jurisdictions, :geo_county, :geo_code_county
  	rename_column :tax_jurisdictions, :geo_city, :geo_code_city
  end
end

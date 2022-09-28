class AddFieldsToTaxJurisdictions < ActiveRecord::Migration[5.1]
  def change
    add_column :tax_jurisdictions, :geo_state, :string
    add_column :tax_jurisdictions, :geo_county, :string
    add_column :tax_jurisdictions, :geo_city, :string
    add_column :tax_jurisdictions, :effective_date, :date
  end
end

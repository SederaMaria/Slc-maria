class AddGeoCodeToTaxJurisdictions < ActiveRecord::Migration[5.1]
  def change
    add_column :tax_jurisdictions, :geo_code, :string, limit: 9
  end
end

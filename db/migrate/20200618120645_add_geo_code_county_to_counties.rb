class AddGeoCodeCountyToCounties < ActiveRecord::Migration[5.1]
  def up
    add_column :counties, :geo_code_county, :string, limit: 3
  end

  def down
    remove_column :counties, :geo_code_county
  end
end

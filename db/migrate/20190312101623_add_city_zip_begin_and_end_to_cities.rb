class AddCityZipBeginAndEndToCities < ActiveRecord::Migration[5.1]
  def change
    add_column :cities, :city_zip_begin, :string
    add_column :cities, :city_zip_end, :string
  end
end

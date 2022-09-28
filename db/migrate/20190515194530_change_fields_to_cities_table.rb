class ChangeFieldsToCitiesTable < ActiveRecord::Migration[5.1]
  def change
    puts "Deleting all Cities CountBefore: #{City.count}"
    City.delete_all
    puts "Deleted all cities CountAfter: #{City.count}"
    remove_column :cities, :zipcode, :string
    remove_column :cities, :abbrevation, :string
    add_column :cities, :geo_state, :string
    add_column :cities, :geo_county, :string
    add_column :cities, :geo_city, :string
  end
end

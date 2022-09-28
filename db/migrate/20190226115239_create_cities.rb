class CreateCities < ActiveRecord::Migration[5.1]
  def change
    create_table :cities do |t|
      t.string :name
      t.integer :county_id
      t.string :zipcode
      t.string :abbrevation

      t.timestamps
    end
  end
end

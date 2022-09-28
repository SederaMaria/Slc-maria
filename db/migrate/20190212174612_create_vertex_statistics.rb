class CreateVertexStatistics < ActiveRecord::Migration[5.1]
  def change
    create_table :vertex_statistics do |t|
      t.string :geo_code, limit: 9
      t.string :geo_state, limit: 2
      t.string :geo_county, limit: 3
      t.string :geo_city, limit: 4
      t.string :state_change_indicator, limit: 1
      t.string :state_description, limit: 20
      t.string :state_sales_tax_rate, limit: 6
      t.string :state_sales_tax_rate_effective_date, limit: 6
      t.string :state_user_tax_rate, limit: 6
      t.string :state_user_tax_rate_effective_date, limit: 6
      t.string :state_rental_tax_rate, limit: 6
      t.string :state_rental_tax_rate_effective_date, limit: 6
      t.string :county_change_indicator, limit: 1
      t.string :county_description, limit: 20
      t.string :county_sales_tax_rate, limit: 6
      t.string :county_sales_tax_rate_effective_date, limit: 6
      t.string :county_user_tax_rate, limit: 6
      t.string :county_user_tax_rate_effective_date, limit: 6
      t.string :county_rental_tax_rate, limit: 6
      t.string :county_rental_tax_rate_effective_date, limit: 6
      t.string :city_change_indicator, limit: 1
      t.string :city_description, limit: 25
      t.string :city_sales_tax_rate, limit: 6
      t.string :city_sales_tax_rate_effective_date, limit: 6
      t.string :city_user_tax_rate, limit: 6
      t.string :city_user_tax_rate_effective_date, limit: 6
      t.string :city_rental_tax_rate, limit: 6
      t.string :city_rental_tax_rate_effective_date, limit: 6
      t.string :city_zip_begin, limit: 9
      t.string :city_zip_end, limit: 9
      t.string :last_changed_date, limit: 6
      t.string :update_number, limit: 3
      t.references :vertex_file, foreign_key: true

      t.timestamps
    end
  end
end

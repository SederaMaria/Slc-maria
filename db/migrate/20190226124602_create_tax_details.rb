class CreateTaxDetails < ActiveRecord::Migration[5.1]
  def change
    create_table :tax_details do |t|
      t.string :geo_code
      t.string :geocode_city
      t.string :geocode_state
      t.string :geocode_county
      t.string :zipcode
      t.integer :vertex_statistics_id
      t.integer :tax_juridication_id
      t.integer :tax_rule_id
      t.integer :county_tax_rule_id
      t.integer :city_tax_rule_id
      t.integer :state_tax_rule_id
      t.integer :state_id
      t.integer :county_id
      t.integer :city_id
      t.string :state_rental_tax_rate, limit: 6
      t.string :state_rental_tax_rate_effective_date, limit: 6

      t.string :state_sales_tax_rate, limit: 6
      t.string :state_sales_tax_rate_effective_date, limit: 6
      t.string :state_use_tax_rate, limit: 6
      t.string :state_use_tax_rate_effective_date, limit: 6

      t.string :county_sales_tax_rate, limit: 6
      t.string :county_sales_tax_rate_effective_date, limit: 6
      t.string :county_use_tax_rate, limit: 6
      t.string :county_use_tax_rate_effective_date, limit: 6
      t.string :county_rental_tax_rate, limit: 6
      t.string :county_rental_tax_rate_effective_date, limit: 6
      t.string :city_sales_tax_rate, limit: 6
      t.string :city_sales_tax_rate_effective_date, limit: 6
      t.string :city_use_tax_rate, limit: 6
      t.string :city_use_tax_rate_effective_date, limit: 6
      t.string :city_rental_tax_rate, limit: 6
      t.string :city_rental_tax_rate_effective_date, limit: 6

      t.string :city_zip_begin, limit: 9
      t.string :city_zip_end, limit: 9


      # t.decimal :sales_tax_percentage, precision: 9, scale: 8
      # t.decimal :up_front_tax_percentage, precision: 9, scale: 8
      # t.decimal :cash_down_tax_percentage, precision: 9, scale: 8
      # t.boolean :tax_down_payment, default: false
      # t.boolean :tax_sales_price, default: false
      # t.boolean :tax_title_fees, default: false
      # t.boolean :tax_document_fee, default: false
      # t.boolean :tax_acquisition_fee, default: false
      # t.boolean :tax_gap_contract_fee, default: false
      # t.boolean :tax_prepaid_maintenence_contract_fee, default: false
      # t.boolean :tax_service_contract_fee, default: false
      # t.boolean :tax_dealer_freight_fee, default: false
      # t.string :tax_methodology
      t.integer :rule_type
      t.timestamps
    end
  end
end

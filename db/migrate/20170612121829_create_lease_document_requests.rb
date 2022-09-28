class CreateLeaseDocumentRequests < ActiveRecord::Migration[5.0]
  def change
    create_table :lease_document_requests do |t|
      t.references :lease_application, foreign_key: true
      t.string  :asset_make
      t.string  :asset_madel
      t.integer :asset_year
      t.string  :asset_vin
      t.string  :asset_color
      t.string  :exact_odometer_mileage
      t.string  :trade_in_make
      t.string  :trade_in_model
      t.string  :trade_in_year
      t.date    :delivery_date
      t.integer :gap_contract_term, default: 0
      t.integer :service_contract_term, default: 0
      t.integer :ppm_contract_term, default: 0
      t.integer :tire_contract_term, default: 0
      t.string  :equipped_with
      t.text    :notes

      t.timestamps
    end
  end
end

class CreateVertexExtracts < ActiveRecord::Migration[5.1]
  def change
    create_table :vertex_extracts do |t|
      t.string :record_type
      t.string :geocode_state
      t.string :geocode_county
      t.string :geocode_city
      t.string :zip_start
      t.string :zip_end
      t.string :sales_tax_rate
      t.timestamps
    end
  end
end

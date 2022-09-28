class CreateTaxRecordTypes < ActiveRecord::Migration[5.1]
  def change
    create_table :tax_record_types do |t|
      t.integer :vertex_record_type, limit: 2
      t.string :record_type_desc, limit: 100

      t.timestamps
    end
  end
end

class CreatePrenotes < ActiveRecord::Migration[5.1]
  def change
    create_table :prenotes do |t|
      t.string :status
      t.string :result
      t.string :response
      t.references :lease_application, foreign_key: true

      t.timestamps
    end
    add_index :prenotes, :status
  end
end

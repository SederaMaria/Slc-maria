class CreateLeaseApplicationStipulations < ActiveRecord::Migration[5.0]
  def change
    create_table :lease_application_stipulations do |t|
      t.references :lease_application, foreign_key: true, null: false
      t.references :stipulation, foreign_key: true, null: false
      t.string :attachment
      t.string :status
      t.timestamps
    end
  end
end

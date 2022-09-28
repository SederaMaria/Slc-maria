class CreateLeaseApplicationCredcos < ActiveRecord::Migration[5.1]
  def change
    create_table :lease_application_credcos do |t|
      t.integer :lease_application_id
      t.string :credco_xml

      t.timestamps
    end
  end
end

class CreateLeaseApplicationGpsUnits < ActiveRecord::Migration[6.0]
  def change
    create_table :lease_application_gps_units do |t|
      t.references :lease_application, null: false, foreign_key: true, index: { name: 'index_gps_units_on_lease_application_id' }
      t.string :gps_serial_number, null: false
      t.boolean :active, default: true, null: false
      t.references :created_by_admin, foreign_key: { to_table: :admin_users }, index: { name: 'index_gps_units_created_by_on_admin_user_id' }
      t.references :updated_by_admin, foreign_key: { to_table: :admin_users }, index: { name: 'index_gps_units_updated_by_on_admin_user_id' }

      t.timestamps
    end
  end
end

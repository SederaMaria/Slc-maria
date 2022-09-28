class CreateLeaseManagementSystems < ActiveRecord::Migration[6.0]
  def change
    create_table :lease_management_systems do |t|
      t.string :api_destination, null: false
      t.boolean :send_leases_to_lms, default: false, null: false
      t.references :lease_management_system_document_status, foreign_key: true, index: { name: 'lms_on_lms_document_status_id' }
      t.timestamps
    end
  end
end

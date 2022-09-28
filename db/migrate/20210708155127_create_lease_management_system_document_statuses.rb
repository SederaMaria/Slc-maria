class CreateLeaseManagementSystemDocumentStatuses < ActiveRecord::Migration[6.0]
  def change
    create_table :lease_management_system_document_statuses do |t|
      t.string :description, null: false
      t.string :value, null: false
      t.timestamps
    end
  end
end

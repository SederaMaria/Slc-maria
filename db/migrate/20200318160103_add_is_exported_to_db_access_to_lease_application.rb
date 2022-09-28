class AddIsExportedToDbAccessToLeaseApplication < ActiveRecord::Migration[5.1]
  def change
    add_column :lease_applications, :is_exported_to_access_db, :boolean, default: false
  end
end

class AddEnabledFlagToLeasePackageDocuments < ActiveRecord::Migration[5.0]
  def change
    add_column :lease_package_templates, :enabled, :boolean, default: true, null: false
  end
end

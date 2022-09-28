class AddPositionToLeasePackageTemplates < ActiveRecord::Migration[5.0]
  def change
    add_column :lease_package_templates, :position, :integer
  end
end

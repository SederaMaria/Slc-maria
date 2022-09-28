class AddArchivedToLeaseApplication < ActiveRecord::Migration[6.0]
  def change
    add_column :lease_applications, :archived, :boolean, default: false
  end
end

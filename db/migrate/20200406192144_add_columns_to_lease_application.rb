class AddColumnsToLeaseApplication < ActiveRecord::Migration[5.1]
  def up
    add_column :lease_applications, :requested_by, :integer, default: nil
    add_column :lease_applications, :approved_by, :integer, default: nil
  end

  def down
    remove_column :lease_applications, :requested_by
    remove_column :lease_applications, :approved_by
  end
end

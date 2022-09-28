class RemoveStatusFromLeaseApplication < ActiveRecord::Migration[5.0]
  def change
    remove_column :lease_applications, :status, :string
  end
end

class AddPrenoteStatusToLeaseApplication < ActiveRecord::Migration[5.1]
  def change
    add_column :lease_applications, :prenote_status, :string
  end
end

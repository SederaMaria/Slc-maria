class AddVehiclePossessionToLeaseApplication < ActiveRecord::Migration[5.1]
  def change
    add_column :lease_applications, :vehicle_possession, :string
  end
end

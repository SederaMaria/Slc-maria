class AddPositionToMileageTier < ActiveRecord::Migration[5.1]
  def change
    add_column :mileage_tiers, :position, :integer
  end
end

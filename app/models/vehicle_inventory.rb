class VehicleInventory < ApplicationRecord
    has_many :vehicle_inventory_images, dependent: :destroy
    belongs_to :inventory_status
end

class VehicleInventoryImage < ApplicationRecord
    belongs_to :vehicle_inventory
    mount_uploader :image, ImageUploader
  
    validates :image, presence: true

end

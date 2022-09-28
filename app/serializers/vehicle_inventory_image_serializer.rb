class VehicleInventoryImageSerializer < ApplicationSerializer
    attributes :id, :image_url, :name

    def name
        object&.image&.file&.filename
    end

  end
  
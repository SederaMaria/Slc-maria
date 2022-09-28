class Api::V1::InventoryStatusController < Api::V1::ApiController
  
    def index
      inventory_status = InventoryStatus.order(id: :asc)
      render json: ActiveModelSerializers::SerializableResource.new(inventory_status, adapter: :json, root: "inventoryStatus").as_json
    end
    
  end
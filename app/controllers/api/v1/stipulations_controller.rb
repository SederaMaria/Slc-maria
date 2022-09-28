class Api::V1::StipulationsController < Api::V1::ApiController
  
  def index
    stipulations = Stipulation.active.order(id: :asc)
    render json: ActiveModelSerializers::SerializableResource.new(stipulations, adapter: :json, root: "stipulations").as_json
  end

end
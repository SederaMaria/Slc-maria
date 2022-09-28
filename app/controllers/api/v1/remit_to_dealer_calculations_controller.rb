class Api::V1::RemitToDealerCalculationsController < Api::V1::ApiController
    skip_before_action :verify_authenticity_token

    def index
        calculation = RemitToDealerCalculation.order(id: :asc)
        render json: ActiveModelSerializers::SerializableResource.new(calculation, adapter: :json, root: "RemitToDealerCalculation", key_transform: :camel_lower).as_json
    end

  end
  
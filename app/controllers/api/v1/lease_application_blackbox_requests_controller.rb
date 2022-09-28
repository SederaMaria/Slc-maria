class Api::V1::LeaseApplicationBlackboxRequestsController < Api::V1::ApiController
    before_action :set_lease_application_blackbox, only: :show
  

    def show
      render json: @lease_application_blackbox, each_serializer: @lease_application_blackbox, adapter: :json, key_transform: :camel_lower, root: false
    end
  
    private
  
    def permitted_params
      params.permit(:id)
    end
  
    def set_lease_application_blackbox
      @lease_application_blackbox = LeaseApplicationBlackboxRequest.find_by(id: permitted_params[:id])
      render json: {message: "Blackbox Request not found."}, status: :not_found unless @lease_application_blackbox.present?
    end
  
  end
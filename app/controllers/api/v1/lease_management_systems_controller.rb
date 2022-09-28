class Api::V1::LeaseManagementSystemsController < Api::V1::ApiController
    skip_before_action :verify_authenticity_token
    include UnderscoreizeParams
    
    before_action :set_lms
  
    def get_details
      if @lms
        render json: ActiveModelSerializers::SerializableResource.new(@lms, adapter: :json, root: "Lms", key_transform: :camel_lower).as_json
      else
        render json: {message: "Lease Management System not found."}, status: :not_found
      end
    end
  
    def update
      if @lms.update(lms_params)
        render json: {message: "Lease Management System updated sucessfully"}
      else
        render json: {message: @lms.errors.full_messages}, status: 500
      end
    end
  
  
    private
  
    def model
        ::LeaseManagementSystem
    end 
  
    def set_lms
        @lms = model.first
    end
  

    def lms_params
      params.permit(:send_leases_to_lms, :api_destination, :lease_management_system_document_status_id)
    end
  end
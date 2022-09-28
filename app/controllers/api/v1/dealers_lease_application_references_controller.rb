class Api::V1::DealersLeaseApplicationReferencesController < Api::V1::ApiController
  include UnderscoreizeParams
  before_action :set_application
  # before_action :get_reference only %i[destroy update]

  def index
    Rails.logger.info("@leaseApplication1 = #{@lease_application}")
    Rails.logger.info("@leaseApplication = #{@lease_application.references}")
    references = @lease_application.references
    render json: references, each_serializer: DealersLeaseApplicationReferencesSerializer, adapter: :json, key_transform: :camel_lower, root: false
    # render json: ActiveModelSerializers::SerializableResource.new(references, serializer: ReferenceSerializer, adapter: :json, key_transform: :camel_lower, root: false).as_json
    # @references = @lease_application.references
    # render :json
    # puts @references
  end

  def create
    reference = @lease_application.references.new(reference_params)
 
    if reference.save
      render json: { message: 'Saved successfully' }, status: :ok
    else
      render json: reference.errors.full_messages
    end


    
  end

  private

  def set_application
    @lease_application = LeaseApplication.find(lease_application_params[:id])
  end

  def get_reference
    @reference = @lease_application.references.find(params[:id])
  end

  def lease_application_params
    # byebug
    params.permit(:id)
  end

  def reference_params
    params.permit(:first_name, :last_name, :phone_number, :state, :city)
  end
end

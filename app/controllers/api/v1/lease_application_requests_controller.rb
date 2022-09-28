class Api::V1::LeaseApplicationRequestsController < Api::V1::ApiController

  before_action :set_lease_application, except: [:request_prenote]
  skip_before_action :verify_authenticity_token
  
  def new_prenote
    PrenoteJob.perform_async(@lease_application.id)
    render json: {
      message: 'Prenote is being requested.'
    }, status: :ok
  end

  private

  def permitted_params
    params.permit(:application_identifier, :type, :filter)
  end

  def set_lease_application
    @lease_application = LeaseApplication.find_by(application_identifier: permitted_params[:application_identifier])
    render json: { 
      errors: { "LeaseApplication" => "does not exist." }
    }, status: :not_found unless @lease_application.present?
  end

end
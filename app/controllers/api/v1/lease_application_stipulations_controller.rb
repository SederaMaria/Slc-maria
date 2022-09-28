class Api::V1::LeaseApplicationStipulationsController < Api::V1::ApiController
  
  before_action :set_application

  def create
    if @lease_application.lease_application_stipulations.create(stipulation_params)
      render json: {message: "Stipulation sucessfully created"}
    else
      render json: {message: @lease_application.errors.full_messages}, status: 500
    end
  end

  private 

  def set_application
    @lease_application = LeaseApplication.where(application_identifier: lease_application_params[:'application-identifier']).first
  end

  def lease_application_params
    params.permit(:'application-identifier')
  end

  def stipulation_params
    params.require(:stipulation).permit(:stipulation_id, :status, :notes, :lease_application_attachment_id)
  end
end
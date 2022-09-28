class Api::V1::LeaseApplicationReportsController < Api::V1::ApiController

  before_action :set_lease_application, except: [:export_access_db, :export_funding_delays]
  skip_before_action :verify_authenticity_token
  
  def export_csv
    ExportLeaseApplicationsJob.perform_async(export_csv_params)
    render json: {
      message: 'Export Job has been scheduled successfully.'
    }, status: :ok
  end

  def export_poa
    if(permitted_params[:type])
      result = ExportPoaService.new(
        lease_application_id: @lease_application.id, 
        type: permitted_params[:type],
        email: current_user.email
        ).call
      
      if result.empty?
        render json: { 
          message: 'Export Job has been scheduled successfully.' 
        }, status: :ok
      else
        render json: { 
          errors: result
        }, status: :not_found
      end
    else
      render json: { 
          errors: { message: 'Param type is missing.' }
        }, status: :bad_request
    end
  end


  def export_access_db
    ExportAccessDbJob.perform_async(email: current_user.email, filter: params[:filter]&.permit!&.to_h)
    render json: {message: "An Access DB Export will shortly be sent to #{current_user.email}."}
  end

  def export_funding_delays
    ExportFundingDelayJob.perform_async(email: current_user.email, filter: params[:filter]&.permit!&.to_h)
    render json: {message: "A Funding Delay Export will shortly be sent to #{current_user.email}."}
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

  def export_csv_params
    {
      email: current_user.email, 
      filter: {
        "application_identifier_contains" => permitted_params[:application_identifier]
      }
    }
  end
  
end
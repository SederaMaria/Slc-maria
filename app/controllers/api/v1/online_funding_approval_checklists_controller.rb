class Api::V1::OnlineFundingApprovalChecklistsController < Api::V1::ApiController

  before_action :set_lease_application
  skip_before_action :verify_authenticity_token
  
  def save_pdf
    create_online_funding_approval_checklist
    OnlineFundingApprovalChecklistPdfJob.perform_async(@lease_application.id)
    render json: {
      message: 'PDF is being saved.'
    }, status: :ok
  end

  def download_pdf
    create_online_funding_approval_checklist
    url = @lease_application.online_funding_approval_checklist.prefilled_for_download
    render json: {
      message: 'PDF is being saved.',
      url: url,
    }, status: :ok
  end

  private

  def create_online_funding_approval_checklist
    if @lease_application.online_funding_approval_checklist.nil?
      @lease_application.create_online_funding_approval_checklist
    end
  end

  def permitted_params
    params.permit(:id)
  end

  def set_lease_application
    @lease_application = LeaseApplication.find permitted_params[:id]
    render json: { 
      errors: { "LeaseApplication" => "does not exist." }
    }, status: :not_found unless @lease_application.present?
  end

end
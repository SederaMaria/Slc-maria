class Api::V1::ReferencesController < Api::V1::ApiController
  before_action :set_reference
  skip_before_action :verify_authenticity_token
  
  def destroy
    @reference.destroy
    render json: {message: 'Reference has been deleted successfully.'}, status: :ok
  end

  private

  def permitted_params
    params.permit(:id)
  end

  def set_reference
    @reference = Reference.find_by(id: permitted_params[:id])
    render json: {message: "Reference not found."}, status: :not_found unless @reference.present?
  end
  
end
class TaxJurisdictionsController < ActionController::API
  include ActionView::Helpers::FormOptionsHelper

  before_action :authenticate_api_user!
  
  def index
    render json: tax_jurisdictions_json_for_index
  end

  private

  def tax_jurisdictions_json_for_index
    if params[:us_state].present?
      options_for_select(tax_jurisdictions_from_state_param)
    else
      []
    end.to_json
  end

  def tax_jurisdictions_from_state_param
    TaxJurisdiction.where(us_state: params[:us_state]).order(:name).pluck(:name)
  end

  def authenticate_api_user! #really this means authenticate any user
    unless dealer_signed_in? || admin_user_signed_in?
      render body: nil, status: :not_found and return
    end
  end  
end

class Api::V1::ModelYearsController < Api::V1::ApiController
  include ActionView::Helpers::FormOptionsHelper

  def index
    make = Make.find_by(id: params[:make_id])
    render json: { model_years: make&.model_years&.active&.map(&:name).uniq.sort }
  end


  def select_options
    options = options_for_select(model_years_for_make_and_year_for_select(asset_make: params[:asset_make], asset_year: params[:asset_year]))
    render json: { select_options: options }
  end


end

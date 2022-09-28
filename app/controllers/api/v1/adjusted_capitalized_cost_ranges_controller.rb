class Api::V1::AdjustedCapitalizedCostRangesController < Api::V1::ApiController
  
  before_action :set_adjusted_capitalized_cost_range, only: [:update]
  before_action :set_make, only: :index
  
  def index
    # credit_tiers = @make.credit_tier_ids.sort
    credit_tiers = CreditTier.where(make_id: permitted_params[:make_id], model_group_id: permitted_params[:model_group_id]).order(:position).pluck(:id)
    @adjusted_capitalized_cost_ranges = model.where("credit_tier_id IN (?)", credit_tiers).order_by_credit_tier_and_lower_limit

    render json: { credit_tiers: credit_tiers,  data: @adjusted_capitalized_cost_ranges}, each_serializer: serializer
  end

  def update
    @adjusted_capitalized_cost_range.update_attribute(
      :acquisition_fee_cents, permitted_params[:acquisition_fee_cents]
      )
    render json: { message: 'Record has been updated successfully.'}, status: :ok
  end

  private

  def permitted_params
    params.permit(:id, :make_id, :acquisition_fee_cents, :model_group_id)
  end

  def set_adjusted_capitalized_cost_range
    @adjusted_capitalized_cost_range = model.find_by(id: permitted_params[:id])
    render json: { message: "Range not found."}, status: :not_found unless @adjusted_capitalized_cost_range.present?
  end

  def set_make
    @make = Make.find_by(id: permitted_params[:make_id])
    render json: { message: "Make not found." }, status: :not_found unless @make.present?
  end

  def model
    ::AdjustedCapitalizedCostRange
  end

  def serializer
    ::AdjustedCapitalizedCostRangeSerializer
  end

end
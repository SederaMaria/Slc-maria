class LeaseCalculatorsController < ActionController::API
  before_action :authenticate_user!
  before_action :must_have_valid_lease_inputs!, except: [:credit_tier_select,:update_total_cash_signin]

  respond_to :json

  def create
    log_calculator_outputs
    render json: json_values, status: :ok
  end

  def credit_tier_select
    make = Make.find_by(name: params[:make], active: true)
    model_group_record = ModelYear.active.for_make_model_and_year(params[:make], params[:model], params[:year]).first&.model_group
    @credit_tiers = CreditTier.where(make_id: make&.id, model_group_id: model_group_record&.id).order(:position)
  end

  private

  def must_have_valid_lease_inputs!
    render_unprocessable unless includes_required_lease_inputs?
  end

  def includes_required_lease_inputs?
    params.dig(:lease_calculator, :us_state).present?
  end

  def render_unprocessable
    render(body: nil, status: :unprocessable_entity) && return
  end

  def log_calculator_outputs
    Rails.logger.info("Calculated: #{lease_calculator.recalculate}")
    Rails.logger.info("Errors: #{lease_calculator.errors_for_json_response}")
  end

  def json_values
    {
      calculations:   lease_calculator.recalculate,
      select_options: lease_calculator.select_options,
      error:          lease_calculator.errors_for_json_response
    }
  end

  def lease_calculator
    @lease_calculator ||= LeaseRecalculator.new(input_values: permitted_params)
  end

  def permitted_params
    params.require(:lease_calculator).permit!
  end

  def authenticate_user!
    render_unauthorized unless dealer_signed_in? || admin_user_signed_in?
  end

  def render_unauthorized
    render(body: nil, status: :unauthorized) && return
  end
end

class Api::V1::CreditTiersController < Api::V1::ApiController
    skip_before_action :verify_authenticity_token, only: [:update]
    before_action :set_credit_tier, only: [:update]

    def index
      #authorize(current_admin_user, 'CreditTier', 'get')
        credit_tiers = CreditTier.where(make_id: credit_tier_params[:make_id], model_group_id: credit_tier_params[:model_group_id]).order(:position)
        credit_tier_ids = credit_tiers.pluck(:id)
        render json: { credit_tiers: credit_tier_ids,  data: credit_tiers}, each_serializer: serializer
    end

    def update
        if @credit_tier.update(credit_tier_params)
            render json: {message: "Credit Tier updated sucessfully"}
          else
            render json: {message: @credit_tier.errors.full_messages}, status: 500
        end
    end

    private
  
    def set_credit_tier
        @credit_tier = model.find credit_tier_params[:id]
    end


    def model
        ::CreditTier
    end

    def serializer
        ::CreditTierSerializer
    end

    def credit_tier_params
      params.permit(:id, :make_id, :payment_limit_percentage, :model_group_id)
    end
    
  end
class Api::V1::BikeInformationController < Api::V1::ApiController

    def makes_name_options 
        begin
          makes = Make.active.order(:name).pluck(:name, :name)
          render json: { makes: makes, mileage_range: mileage_tier_collection }
        rescue => e
          render json: {message: "Error Fetching makes"}, status: :internal_server_error 
        end
    end


    def years_options
        begin
            make = Make.where(name: params[:make]).first
            years = make&.application_setting&.model_year_range_descending&.to_a || []
            credit_tiers = CreditTier.for_make_name(make&.name).order(:position).pluck(:id, :description)&.uniq(&:last)&.map { |credit| { value: credit[1], label: credit[1], id: credit[0] } }
            render json: { years: years, credit_tiers: credit_tiers }
        rescue => e
            render json: {message: "Error Fetching makes"}, status: :internal_server_error 
        end
    end

    def models_options
        begin
            options = model_years_for_make_and_year_for_select(asset_make: params[:make], asset_year: params[:year])
            render json: { models: options }
        rescue => e
            Rails.logger.info(e)
            render json: {message: "Error Fetching model"}, status: :internal_server_error 
        end
    end

    def credit_tier_options
        make = Make.find_by(name: params[:make], active: true)
        model_group_record = ModelYear.active.for_make_model_and_year(params[:make], params[:model], params[:year]).first&.model_group
        credit_tiers = CreditTier.where(make_id: make&.id, model_group_id: model_group_record&.id).order(:position).map do |tier|
            {
                value: tier.id,
                label: tier.description
            }
        end
        render json: { credit_tiers: credit_tiers }
    rescue
        render json: { message: "Error Fetching Credit Tiers" }, status: :internal_server_error
    end
end
class Api::V1::DealerRepresentativesController < Api::V1::ApiController
    skip_before_action :verify_authenticity_token

    def index
        dealer_representatives = DealerRepresentative.order(id: :asc)
        render json: ActiveModelSerializers::SerializableResource.new(dealer_representatives, adapter: :json, root: "dealerRepresentatives", key_transform: :camel_lower).as_json
    end

  def active
    dealer_representatives = DealerRepresentative.joins(:admin_user).order("admin_users.id ASC").where("admin_users.is_active = true")
    render json: ActiveModelSerializers::SerializableResource.new(dealer_representatives, adapter: :json, root: "dealerRepresentatives", key_transform: :camel_lower).as_json
  end

  end
  
class Api::V1::DealerDealershipController < Api::V1::ApiController
    include UnderscoreizeParams
 
    def banking_information
      @info = LeaseApplication.find(params[:id])
      serializeJson
    end
  
    def update_banking_information
      @info = LeaseApplication.find(params[:id])
      if @info.update(dealer_dealership_params)
        serializeJson
      else
        render json: {message: @info.errors.full_messages}, status: 500
      end
    end
  
    private

    def dealer_dealership_params
      params.permit(
                    :payment_bank_name, 
                    :payment_aba_routing_number, 
                    :payment_account_number, 
                    :payment_account_type 
                )
    end

    def serializeJson 
      render json: @info, serializer: LeaseApplicationSerializer, adapter: :json, key_transform: :camel_lower, root: false
    end
end
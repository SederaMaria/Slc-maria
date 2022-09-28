module Api
  module V1
    class ApplicationSettingsController < Api::V1::ApiController
      before_action :set_application_setting, only: [:update]

      def index
        application_settings = ApplicationSetting.all.order('id asc')
        render json: ActiveModelSerializers::SerializableResource.new(application_settings, adapter: :json).as_json
      end


      def update
        if @application_setting.update(application_setting_params)
            render json: {message: "Credit Tier updated sucessfully"}
          else
            render json: {message: @application_setting.errors.full_messages}, status: 500
        end
      end

      private

      def set_application_setting
        @application_setting = model.find params[:id]
      end

      def application_setting_params
        params.require(:application_setting).permit(:high_model_year,  :low_model_year,  :acquisition_fee,  
          :dealer_participation_sharing_percentage_24,  :base_servicing_fee,  :dealer_participation_sharing_percentage_36,  
          :dealer_participation_sharing_percentage_48,  :residual_reduction_percentage_24,  :residual_reduction_percentage_36,  
          :residual_reduction_percentage_48,  :residual_reduction_percentage_60,  :dealer_participation_sharing_percentage_60,  
          :global_security_deposit,  :enable_global_security_deposit)
      end

      def model
        ApplicationSetting
      end

    end
  end
end
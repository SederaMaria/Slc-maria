module Api
  module V1
    class Api::V1::CommonApplicationSettingsController < Api::V1::ApiController

      def index
        @scheduling_days = CommonApplicationSetting.all
      end

      def update_scheduling_day
        authorize(current_user, 'AdminUser', 'update')
        if params[:scheduling_day].present?
          CommonApplicationSetting.first.update(scheduling_day: params[:scheduling_day])
          render json: { message: 'Scheduling Day updated successfully.' }
        else
          render json: { errors: [ { detail: 'Error updating scheduling day.' }]}, status: 401
        end
        rescue StandardError
        render json: { errors: [ { detail: 'Error updating scheduling day.' }]}, status: 401
      end
    end
  end
end

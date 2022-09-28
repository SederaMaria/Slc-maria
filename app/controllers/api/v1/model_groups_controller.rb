module Api
  module V1
    class ModelGroupsController < Api::V1::ApiController

      before_action :set_make, only: :index

      def index        
        @make = Make.find_by(id: params[:make_id])
        @model_groups = @make&.model_groups.order('sort_index asc').select(:id,:name,:sort_index)
        render json: { message: "Model Groups List Data", model_groups: @model_groups }, each_serializer: serializer
      end

      def sort_order
        authorize(current_user, 'AdminUser', 'update')
        if params[:modelGroups].present?          
          params[:modelGroups].each.with_index(1) do |model_group|                     
            ModelGroup.update_sort_index(model_group[:id], model_group[:sortIndex])
          end
          render json: { message: 'Sort order updated successfully.' }
        else          
          render json: { errors: [ { detail: 'Error updating sort order.' }]}, status: 400
        end
      rescue StandardError        
        render json: { errors: [ { detail: 'Error updating sort order.' }]}, status: 400
      end

      private
      def set_make
        @make = Make.find_by(id: params[:make_id])
        render json: { message: "Make not found." }, status: :not_found unless @make.present?
      end

      def serializer
        ::ModelGroupSerializer
      end

    end
  end
end
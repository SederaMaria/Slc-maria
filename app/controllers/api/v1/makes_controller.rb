module Api
  module V1
    class MakesController < Api::V1::ApiController
      def index
        @makes = Make.active.order(:name)
      end
    end
  end
end
class Api::V1::StatesController < Api::V1::ApiController

  def index
    render json: { states: States::SELECT2_ABBREVIATED_ALL }
  end

end

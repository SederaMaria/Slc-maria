class Api::V1::BannerController < Api::V1::ApiController  
  include UnderscoreizeParams

  before_action :set_banner, except: [:index]
  before_action :get_admin_id
  
  def index      
    banner = Banner.order(id: :asc)
    render json: ActiveModelSerializers::SerializableResource.new(      
      banner, 
      adapter: :json, 
      key_transform: :camel_lower,
      root: false
    ).as_json
  end

  def update
    begin
      merge_params = {updated_by_admin_id: @admin_id}
      @banner.update(banner_params.merge(merge_params))        
      render json: { message: 'Banner has been successfully updated.' }, status: :ok
    rescue => exception
      Rails.logger.info(exception.message)
      render json: {message: 'Error updating banner message'}, status: 400
    end
  end  

  private

  def get_admin_id
    if current_user 
      @admin_id = current_user.id
    else
      render json: {message: 'Permission denied'}, status: 401
    end
  end

  def set_banner
    @banner = Banner.find(params[:id])
  end

  def banner_params
    params.permit(:id, :headline, :message, :active, :updated_by_admin_id)
  end

end
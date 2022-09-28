class Api::V1::LeaseApplicationGpsUnitsController < Api::V1::ApiController  
  skip_before_action :verify_authenticity_token

  include UnderscoreizeParams
  before_action :get_admin_id
  before_action :set_unit, except: [:create]

  def index    
    render json: @lease_application_gps_unit,    
      adapter: :json,
      key_transform: :camel_lower,
      root: false
  end

  def create
    begin
      merge_params = {created_by_admin_id: @admin_id}
      new_unit = LeaseApplicationGpsUnit.new(gps_unit_params.merge(merge_params))
      
      if new_unit.save
        render json: {message: "Successfully created", id: new_unit.id}, status: 201
      else
        render json: {message: new_unit.errors.full_messages}, status: 400
      end
    rescue => exception
      Rails.logger.info(exception.message)
      render json: {message: "Error creating GPS unit"}, status: 400 
    end
  end

  def update
    begin
      merge_params = {updated_by_admin_id: @admin_id}
      @lease_application_gps_unit.update(gps_unit_params.merge(merge_params))        
      render json: { message: 'GPS unit has been successfully updated.' }, status: :ok
    rescue => exception
      Rails.logger.info(exception.message)
      #render json: {message: @lease_application_gps_unit.errors.full_messages}, status: 500
      render json: {message: "Error updating GPS unit"}, status: 400
    end
  end

  def destroy
    begin
      @lease_application_gps_unit.destroy
      render json: { message: 'GPS unit has been successfully deleted.' }, status: :ok
    rescue => exception
      Rails.logger.info(exception.message)
      render json: {message: "Error deleting GPS unit"}, status: 400
    end
  end  

  private

  def get_admin_id
    if current_user 
      @admin_id = current_user.id
    else
      render json: {message: "Permission denied"}, status: 401
    end
  end

  def set_unit
    @lease_application_gps_unit = LeaseApplicationGpsUnit.find(params[:id])
  end

  def gps_unit_params
    params.permit(:lease_application_id, :gps_serial_number, :active, :created_by_admin_id, :updated_by_admin_id)
  end
end
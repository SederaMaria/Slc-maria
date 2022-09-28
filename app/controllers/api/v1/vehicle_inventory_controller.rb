class Api::V1::VehicleInventoryController < Api::V1::ApiController
    skip_before_action :verify_authenticity_token
    include UnderscoreizeParams

    before_action :set_inventory, except: [:index, :create]
    
    def index
        authorize(current_user, 'VehicleInventory', 'get')
        vehicle_inventory = VehicleInventory.order(id: :asc)
        render json: ActiveModelSerializers::SerializableResource.new(vehicle_inventory, adapter: :json, root: "vehicleInventory", key_transform: :camel_lower).as_json
    end

    def show
        authorize(current_user, 'VehicleInventory', 'get')
        render json: ActiveModelSerializers::SerializableResource.new(@vehicle_inventory, adapter: :json, root: "vehicleInventory", key_transform: :camel_lower).as_json
    end

    def create
        authorize(current_user, 'VehicleInventory', 'create')
        begin
            new_inventory = VehicleInventory.new(vehicle_inventory_params)
            if new_inventory.save
                images_params.each do |img|
                    new_inventory.vehicle_inventory_images.create(img)
                end
                render json: {message: "Successfully created", id: new_inventory.id}
            else
                render json: {message: new_inventory.errors.full_messages}, status: :internal_server_error
            end
          rescue => exception
            Rails.logger.info(exception.message)
            render json: {message: "Error Updating"}, status: :internal_server_error 
          end
    end
    
    def update
        authorize(current_user, 'VehicleInventory', 'update')
        begin
            if @vehicle_inventory.update(vehicle_inventory_params)
                render json: {message: "Successfully updated"}
            else
                render json: {message: @vehicle_inventory.errors.full_messages}, status: :internal_server_error
            end
          rescue => exception
            Rails.logger.info(exception.message)
            render json: {message: "Error Updating"}, status: :internal_server_error 
          end
    end

    def destroy
        authorize(current_user, 'VehicleInventory', 'delete')
        begin
            if @vehicle_inventory.destroy
                render json: {message: "Successfully deleted"}
            else
                render json: {message: @vehicle_inventory.errors.full_messages}, status: :internal_server_error
            end
          rescue => exception
            Rails.logger.info(exception.message)
            render json: {message: "Error deleting"}, status: :internal_server_error 
          end
    end

    def upload_image
        authorize(current_user, 'VehicleInventory', 'update')
        begin
            images_params[:images].each do |image|
                @vehicle_inventory.vehicle_inventory_images.create({image: image})
            end
            render json: {message: "Successfully updated"}
        rescue => exception
            Rails.logger.info(exception.message)
            render json: {message: "Error Updating"}, status: :internal_server_error 
        end
    end

    def delete_image
        authorize(current_user, 'VehicleInventory', 'update')
        begin
            if @vehicle_inventory.vehicle_inventory_images.find(params[:image_id]).delete
                render json: {message: "Successfully deleted"}
            else
                render json: {message: @vehicle_inventory.errors.full_messages}, status: :internal_server_error
            end
        rescue => exception
            Rails.logger.info(exception.message)
            render json: {message: "Error Updating"}, status: :internal_server_error 
        end
    end

    def nada_value_history
        model_years = ModelYear.for_make_model_and_year(@vehicle_inventory&.asset_make, @vehicle_inventory&.asset_model, @vehicle_inventory&.asset_year)
        render json: ActiveModelSerializers::SerializableResource.new(model_years, adapter: :json, root: "modelYears", key_transform: :camel_lower).as_json
    end


    private 

    def set_inventory
        @vehicle_inventory = VehicleInventory.find(params[:id])
    end

    def vehicle_inventory_params
        params.require(:vehicle_inventory).permit(
            :asset_make, :asset_model, :asset_year, :asset_vin, :asset_color, :exact_odometer_mileage, 
            :new_used, :stock_number, :intake_date, :sale_date, :invetory_status, :inventory_status_id
        )
    end

    def images_params
        params.permit(images: [])
    end


end
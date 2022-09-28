class VehicleInventorySerializer < ApplicationSerializer
    attributes :id, :asset_make, :asset_model, :asset_year, :asset_vin, :asset_color, :exact_odometer_mileage, 
                :new_used, :stock_number, :intake_date, :sale_date, :inventory_status, :inventory_status_id, :at_acquisition, :at_sale, :model_year

    has_many :vehicle_inventory_images,              serializer: VehicleInventoryImageSerializer

    def inventory_status
        object&.inventory_status&.description
    end

    def inventory_status_id
        object&.inventory_status&.id
    end


    def at_acquisition
        model_year = ModelYear.for_make_model_and_year(object&.asset_make, object&.asset_model, object&.asset_year).between_start_end(object&.intake_date).first
        custom_model_years(model_year)
    end    

    def at_sale
        model_year = ModelYear.for_make_model_and_year(object&.asset_make, object&.asset_model, object&.asset_year).between_start_end(object&.sale_date).first
        custom_model_years(model_year)
    end

    def model_year
        model_year = ModelYear.for_make_model_and_year(object&.asset_make, object&.asset_model, object&.asset_year).first
        {
            name: model_year&.name,
            makeId: model_year&.make&.id
        }
    end


    private
    
    def custom_model_years(model_year)
        [{
            start_date: model_year&.start_date&.strftime('%B %d, %Y'),
            nada_avg_retail: model_year&.nada_avg_retail.to_money.format,
            nada_rough: model_year&.nada_rough.to_money.format,

        }]
    end

end
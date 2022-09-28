class Api::V1::VinVerificationController < Api::V1::ApiController
    # GET        /api/v1/vin_verification/verify-vin
    def verify_vin

        @vin = params["vin"]
        get_value
        begin
            if @response["Message"] == "Vehicle Not Found"
                render json: { message: "Vehicle Not Found" }, status: 404
            elsif @response["error"].present?
                render json: { message: @response["error"] }, status: 503
            else
                vehicle_info = {
                    model: format_model(vehicle_make, vehicle_year, vehicle_model),
                    year: vehicle_year,
                    make: format_make(vehicle_make)
                }
                render json: { message: "Vehicle Found", vehicleInfo: vehicle_info }
            end
        rescue => e
            Rails.logger.info(e)
            render json: { message: "Error verifying Vehicle" }, status: 500
        end

    end


    private 

    def format_make(vehicle_make)
        makes = Make.active.pluck(:name)
        makes.select{ |x| x.upcase == vehicle_make.upcase }&.first
    end

    def format_model(vehicle_make, vehicle_year, vehicle_model)
        asset_models = model_years_for_make_and_year_for_select(asset_make: format_make(vehicle_make), asset_year: vehicle_year)
        asset_models.find { |x| x.first.upcase == vehicle_model.upcase }&.first
    end

    def vehicle_model
        @response["GetValueGuide"]&.[]("Info")&.[]("VehicleModel")
    end

    def vehicle_year
        @response["GetValueGuide"]&.[]("Info")&.[]("VehicleYear")
    end

    def vehicle_make
        @response["GetValueGuide"]&.[]("Info")&.[]("VehicleBrand")
    end

    def get_value
        begin
            @response ||= JSON.parse(RestClient::Request.execute(method: :post, url: "#{ENV['MORPHEUS_URL']}/api/v1/verify" , payload:  {vin: @vin})) 
            Rails.logger.info(@response)
        rescue RestClient::ExceptionWithResponse => e
            begin
                @response ||= JSON.parse(e.response)
            rescue JSON::ParserError
                # If its not a JSON response, assume a server error from Morpheus server
                @response = { "error" => "MORPHEUS server error" }
            end
        rescue Errno::EADDRNOTAVAIL, Errno::ECONNREFUSED => e
            Rails.logger.error("MORPHEUS is unreachable #{e.message}")
            @response = { "error" => "MORPHEUS is unreachable" }
        rescue => e
            Rails.logger.error("#{e.message}\n#{e.backtrace.join("\n")}")
            @response = { "error" => "Internal Server Error" }
        end
        
    end

end
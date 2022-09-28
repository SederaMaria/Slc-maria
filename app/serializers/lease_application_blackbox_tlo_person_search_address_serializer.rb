class LeaseApplicationBlackboxTloPersonSearchAddressSerializer < ApplicationSerializer
    attributes :id, :date_first_seen, :date_last_seen, :street_address_1, :city, :state, :zip_code, :county, :zip_plus_four, :building_name, :description, :subdivision_name, :lease_application_blackbox_request_id, :created_at, :updated_at

    def date_first_seen
        object&.date_first_seen&.strftime("%m/%d/%Y")
    end
 
    def date_last_seen
        object&.date_last_seen&.strftime("%m/%d/%Y")
    end
        
end
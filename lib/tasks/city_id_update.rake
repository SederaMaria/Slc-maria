namespace :lease_applications do
  
  desc "Update missing city_id"
  task update_city_id:  :environment do
  puts "Started update of city_ids"
  LeaseApplication.where(expired: false)
                    .where.not(lessee_id: nil)
                    .where.not(lease_calculator_id: nil)
                    .where.not(dealer_id: nil)
                    .where.not(application_identifier: nil).find_each do |l|
      state_obj = UsState.find_by_abbreviation(l.lessee&.home_address&.state)
      dealer_state = l.dealer&.dealership&.address&.state
            if (state_obj.tax_jurisdiction_type.name.include?("Customer") || (state_obj.tax_jurisdiction_type.name.include?("Dealer") && (dealer_state != state_obj.abbreviation)))
              city_name =  l.lessee&.home_address&.city
              zipcode = l.lessee&.home_address&.zipcode
              county_name = l.lessee&.home_address&.county
              county = County.where(us_state_id: state_obj&.id, name: county_name).first
            else
              city_name = l.dealer&.dealership&.address&.city
              zipcode = l.dealer&.dealership&.address&.zipcode
              county_name = l.dealer&.dealership&.address&.county
              county = County.where(us_state_id: state_obj&.id, name: county_name).first
            end
        city = City.where(county_id: county&.id, name: city_name, us_state_id: state_obj&.id).where("'#{zipcode}' between city_zip_begin and city_zip_end").first
        l.city_id = city&.id
        if l.save!
          puts "Successfully updated city_id for #{l.application_identifier}"
        else
          puts "Failed to update city_id for #{l.application_identifier}"
        end
    end
    puts "Update Completed!"
  end
end
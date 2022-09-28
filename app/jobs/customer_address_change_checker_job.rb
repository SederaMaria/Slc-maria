class CustomerAddressChangeCheckerJob < ApplicationJob
  queue_as :default
  
  def perform(zipcode, city, lease_validation)
    @old_zipcode = zipcode
    @old_city = city
    @lease_application = lease_validation&.lease_application
    @lease_validation = LeaseValidation.where(id: lease_validation.id).first.validatable
    @calculator = lease_validation&.lease_application&.lease_calculator
    @calculator_us_state = UsState.find_by(name: @calculator&.us_state)
    compare_now
  end
  
  private
  
  def compare_now
    is_by_county = @calculator_us_state.tax_jurisdiction_type.name == "Customer's County/Town"
    is_by_zipcode = @calculator_us_state.tax_jurisdiction_type.name == "Customer's ZIP Code"
    recalculate = false

    if (@old_zipcode != @lease_validation.zipcode) && is_by_zipcode
      counties = TaxJurisdiction.where(us_state: @calculator&.us_state).order(:name).pluck(:name)
      in_zipcodes = counties.include?(@lease_validation&.zipcode&.first(5))
      not_current_zipcode = @calculator.tax_jurisdiction.to_s != @lease_validation.zipcode.to_s
      if in_zipcodes && not_current_zipcode
        @calculator.tax_jurisdiction = @lease_validation.zipcode.first(5)
        @calculator.save!
        recalculate = true
        Rails.logger.info("Customer's Zip Code has change to #{@calculator.tax_jurisdiction}")
      end
    end

    if (@old_city != @lease_validation.city) && is_by_county
      all_other_counties = 'All Other Counties'
      counties = TaxJurisdiction.where(us_state: @calculator&.us_state).order(:name).pluck(:name).map{|x| x.remove('County').squish}.map(&:upcase)
      has_all_other_counties = counties.include?(all_other_counties.upcase)
      in_counties = counties.include?(@lease_validation&.city&.upcase)
      not_current_county = @calculator.tax_jurisdiction.upcase != @lease_validation.city.upcase

      if (in_counties || has_all_other_counties) && not_current_county

        with_county_labels = ['florida', 'pennsylvania'].include?(@calculator&.us_state)
        @calculator.tax_jurisdiction = @lease_validation&.city&.humanize
        @calculator.tax_jurisdiction = "#{@lease_validation&.city&.humanize} County" if with_county_labels

        if has_all_other_counties && not_current_county
          @calculator.tax_jurisdiction = all_other_counties
        end

        @calculator.save!
        recalculate = true
        Rails.logger.info("Customer's County/Town change to #{@calculator.tax_jurisdiction}")
      end
    end

    RecalculateLeaseCalculatorsJob.perform_later(lease_calculator_id: @calculator.id) if recalculate

  end
end
# == Schema Information
#
# Table name: addresses
#
#  id         :integer          not null, primary key
#  street1    :string
#  street2    :string
#  city       :string
#  state      :string
#  zipcode    :string
#  created_at :datetime         not null
#  updated_at :datetime         not null
#  county     :string
#

class AddressSerializer < ApplicationSerializer
  attributes :id, :city, :state, :zipcode, :street1, :street2, :county,
             :newCityCollectionValue, :newCityValue, :cityId, :newCity, :geoCodeState, :geoCodeCounty, :geoCodeCity,
             :cityOptions, :stateOptions, :countyOptions

  def cityId
    object&.city_id&.to_s
  end

  # DEPRECATED: `addresses.county`, use `Address.new_city`
  def county
    object&.new_city&.county_id&.to_s
  end

  def geoCodeState
    object&.new_city&.us_state&.geo_code_state
  end

  def geoCodeCounty
    object&.new_city&.county&.geo_code_county
  end

  def geoCodeCity
    object&.new_city&.geo_city
  end

  def newCityValue
    object&.new_city_value
  end

  def newCityCollectionValue
    object&.new_city_collection_value
  end

  def newCity
    {
      city: object&.new_city&.name,
      state: object&.new_city&.us_state&.abbreviation,
      county: object&.new_city&.county&.name
    }
  end

  def countyOptions
    [object&.new_city&.county&.id, object&.new_city&.county&.name]
  end

  def stateOptions
    [object&.new_city&.us_state&.id, object&.new_city&.us_state&.abbreviation]
  end

  def cityOptions
    [object&.new_city&.id, object&.new_city&.name]
  end
end

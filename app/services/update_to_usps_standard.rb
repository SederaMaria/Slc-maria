require 'smartystreets_ruby_sdk/static_credentials'
require 'smartystreets_ruby_sdk/client_builder'
require 'smartystreets_ruby_sdk/us_street/lookup'

class UpdateToUspsStandard
  def initialize(lease_validation)
    @lease_validation = lease_validation
    @address = lease_validation.validatable
    @address_dup = address.clone
    auth_id = ENV['SMARTY_AUTH_ID']
    auth_token = ENV['SMARTY_AUTH_TOKEN']
    credentials = SmartyStreets::StaticCredentials.new(auth_id, auth_token)
    @client = SmartyStreets::ClientBuilder.new(credentials).build_us_street_api_client
  end

  def self.call(address)
    new(address).call
  end

  def call
    old_address = address
    zipcode_was = address.zipcode
    city_was = address.city
    address.street1 = data[0]['delivery_line_1']
    address.street2 = data[0]['delivery_line_2']
    address.city    = data[0]['components']['city_name']
    address.zipcode = zip_with_plus_4
    address.county  = data[0]['metadata']['county_name']
    address.save!
    CustomerAddressChangeCheckerJob.perform_now(zipcode_was, city_was, @lease_validation)
  end

private
  attr_reader :address, :client

  def zip_with_plus_4
    "#{data[0]['components']['zipcode']}-#{data[0]['components']['plus4_code']}"
  end

  def data
    lookup           = SmartyStreets::USStreet::Lookup.new
    lookup.street    = address.street1
    lookup.street2   = address.street2
    lookup.city      = address.city
    lookup.state     = address.state
    @result        ||= client.send_lookup(lookup)
  end
end

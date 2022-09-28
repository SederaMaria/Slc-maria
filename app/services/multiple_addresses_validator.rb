require 'smartystreets_ruby_sdk/static_credentials'
require 'smartystreets_ruby_sdk/client_builder'
require 'smartystreets_ruby_sdk/us_street/lookup'

class MultipleAddressesValidator
  attr_reader :addresses
  attr_reader :lookup
  attr_reader :client
  attr_reader :batch

  def initialize(addresses)
    auth_id = ENV['SMARTY_AUTH_ID']
    auth_token = ENV['SMARTY_AUTH_TOKEN']
    credentials = SmartyStreets::StaticCredentials.new(auth_id, auth_token)
    @addresses = addresses
    @client = SmartyStreets::ClientBuilder.new(credentials).build_us_street_api_client
    @batch = SmartyStreets::Batch.new
  end

  def call
    prepare_batches
    client.send_batch(batch)
    batch.map{ |l| l.result.present? }
  end

  #shortcut for now - all must be valid - works just fine when only validating one address
  def valid?
    call.all? {|response| response == true }
  end


  private

  def prepare_batches
    addresses.each do |address|
      lookup = SmartyStreets::USStreet::Lookup.new
      lookup.street = address[:street]
      lookup.city = address[:city]
      lookup.state = address[:state]
      lookup.zipcode = address[:zipcode]
      batch.add(lookup)
    end
  end
end

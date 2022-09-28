require 'rest-client'

class TransferVendorToLeasepakService

  def initialize(dealership:)
    @dealership = dealership
    @url = ENV['BRIDGING_API_URL']
  end

  def transfer
    CustomLogger.log_info("#{self.class.to_s}#transfer", "Initiated transfer for Dealership: #{@dealership.id}")
    response = JSON.parse(RestClient.get "#{@url}/create_vendor_leasepak?dealership_id=#{@dealership.id}")
    CustomLogger.log_info("#{self.class.to_s}#transfer", "Completed transfer for Dealership Id: #{@dealership.id}, RESPONSE: #{response}")
  end

end
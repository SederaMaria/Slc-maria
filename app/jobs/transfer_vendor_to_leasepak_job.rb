class TransferVendorToLeasepakJob
  include Sidekiq::Worker
  sidekiq_options unique: :until_executed, retry: 30

  sidekiq_retry_in do |count, exception|
    20 * (count + 1) # (i.e. 20, 40, 60, 80, 100)
  end

  def perform(dealership_id)
    dealership = Dealership.where(id: dealership_id).first
    if dealership
      TransferVendorToLeasepakService.new(dealership: dealership).transfer
    else
      CustomLogger.log_info("#{self.class.to_s}", "Record not found for Dealership: #{dealership.id}")
    end
  rescue => e
    CustomLogger.log_info("#{self.class.to_s}", "Failed transfering vendor to leasePak for Dealership: #{e.to_s}")
  end
end
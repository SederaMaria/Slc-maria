class TransferStatusToLeasepakJob
  include Sidekiq::Worker
  sidekiq_options unique: :until_executed, retry: 30

  sidekiq_retry_in do |count, exception|
    20 * (count + 1) # (i.e. 20, 40, 60, 80, 100)
  end

  sidekiq_retries_exhausted do |msg, ex|
    LeasepakMailer.status_transfer_failure(msg['app_id'])
  end

  def perform(app_id)
    app = LeaseApplication.where(id: app_id).first
    if app
      CustomLogger.log_info("#{self.class.to_s}", "Record found for Lease Application: #{app.id}")
      TransferStatusToLeasepakService.new(lease_application: app).transfer
    else
      CustomLogger.log_info("#{self.class.to_s}", "Record not found for Lease Application: #{app.id}")
    end
  rescue => e
    CustomLogger.log_info("#{self.class.to_s}", "Failed transfering status to leasePak for Lease Application: #{e.to_s}")
  end
end

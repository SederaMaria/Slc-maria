class ValidateAddressJob < ApplicationJob
  queue_as :default

  def perform(id)
    if lease_validation = LeaseValidation.status_unvalidated.where(id: id).first
      if MultipleAddressesValidator.new(lease_validation.verifiable_attribute).valid?
        log("Valid Status")
        lease_validation.validate_status!
        UpdateToUspsStandard.call(lease_validation)
      else
        log("Invalid Status")
        lease_validation.invalidate_status!
      end
    end
  rescue => exception
    log("#{exception} #{exception.backtrace}")
  end
  
  def log(msg)
    Rails.logger.info(" [#{Time.now.utc.strftime('%B %-d %Y at %r %Z')}] - ValidateAddressJob: #{msg}")
  end
  
end

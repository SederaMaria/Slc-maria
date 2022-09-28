class ValidateEmailJob < ApplicationJob
  queue_as :default

  def perform(id)
    if lease_validation = LeaseValidation.status_unvalidated.where(id: id).first
      if EmailValidator.new(lease_validation.verifiable_attribute).valid?
        lease_validation.validate_status!
      else
        lease_validation.invalidate_status!
      end
    end
  end
end

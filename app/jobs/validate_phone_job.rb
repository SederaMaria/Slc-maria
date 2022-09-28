class ValidatePhoneJob < ApplicationJob
  queue_as :default
  attr_accessor :phone_number

  def perform(id)
    if lease_validation = LeaseValidation.status_unvalidated.where(id: id).first
      @phone_number = lease_validation.verifiable_attribute

      if number_service.valid?
        # apply carrier info on validatable object, in this case a Lessee
        lease_validation.validatable.update_carrier(lease_validation.verifiable_attribute_name, number_service.carrier_lookup)
        lease_validation.validate_status!
      else
        lease_validation.invalidate_status!
      end
    end
  end

  def number_service
    @service ||= PhoneNumberServices.new(phone_number)
  end
end

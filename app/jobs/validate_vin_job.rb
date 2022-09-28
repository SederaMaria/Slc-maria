class ValidateVinJob < ApplicationJob
  queue_as :default

  def perform(id)
    if lease_validation = VinValidation.status_unvalidated.where(id: id).first
      verification_object = VinVerificationNpa.new(**lease_validation.verifiable_attributes)
      if verification_object.vin_matches_make_model_and_year?
        VinValidation.transaction do
          lease_validation.npa_validation_response = verification_object.response
          lease_validation.validate_status
          lease_validation.save
        end
      else
        VinValidation.transaction do
          lease_validation.npa_validation_response = verification_object.response
          lease_validation.invalidate_status
          lease_validation.save
        end
      end
    end
  end
end

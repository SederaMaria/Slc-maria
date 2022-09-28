# == Schema Information
#
# Table name: lease_validations
#
#  id                      :integer          not null, primary key
#  lease_application_id    :integer
#  validatable_type        :string
#  validatable_id          :integer
#  type                    :string
#  status                  :string
#  original_value          :string
#  revised_value           :string
#  created_at              :datetime         not null
#  updated_at              :datetime         not null
#  validation_response     :text
#  npa_validation_response :jsonb            not null
#
# Indexes
#
#  index_lease_validations_on_id_and_type                          (id,type)
#  index_lease_validations_on_lease_application_id                 (lease_application_id)
#  index_lease_validations_on_validatable_type_and_validatable_id  (validatable_type,validatable_id)
#
# Foreign Keys
#
#  fk_rails_...  (lease_application_id => lease_applications.id)
#

class MobilePhoneValidation < LeaseValidation
  def verifiable_attribute_name
    'mobile_phone_number'
  end

  def verifiable_attribute
    validatable.send(verifiable_attribute_name)
  end

  def verify
    ValidatePhoneJob.set(wait: 30.seconds).perform_later(self.id)
  end
end

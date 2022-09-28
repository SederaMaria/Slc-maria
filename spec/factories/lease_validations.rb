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

FactoryBot.define do
  factory :lease_validation do
    lease_application
    validatable factory: :lease_application
    status { "status_unvalidated" }
    original_value { '' }
    revised_value { '' }

    factory :vin_validation, class: VinValidation do
      validatable factory: :lease_document_requests
    end

    factory :home_phone_validation, class: HomePhoneValidation do
      validatable factory: :lessee
      type { 'HomePhoneValidation' }
    end
  end
end

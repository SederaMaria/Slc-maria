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

class LeaseValidation < ApplicationRecord
  include AASM

  belongs_to :lease_application
  belongs_to :validatable, polymorphic: true

  aasm column: 'status' do
    state :status_unvalidated, initial: true
    state :status_valid, :status_invalid, :status_corrected, :status_error

    event :validate_status do
      transitions from: [:status_unvalidated, :status_corrected], to: :status_valid
    end

    event :invalidate_status do
      transitions from: [:status_unvalidated, :status_corrected], to: :status_invalid
    end

    event :correct_status do
      transitions from: :status_invalid, to: :status_corrected
    end

    event :error_occured do
      transitions from: [:status_unvalidated, :status_valid, :status_invalid, :status_corrected], to: :status_error
    end
  end

  def verifiable_attribute
    raise RuntimeError("must be implemented in a Subclass only")
  end

  def verify
    raise RuntimeError("must be implemented in Subclasses")
  end

  def display_label
    verifiable_attribute
  end

  def is_phone_validation?
    type.include?('PhoneValidation')
  end

  def phone_carrier
    validatable.send("#{verifiable_attribute_name}_carrier")
  end

  def phone_line
    validatable.send("#{verifiable_attribute_name}_line")
  end
end


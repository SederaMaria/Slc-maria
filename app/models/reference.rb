# == Schema Information
#
# Table name: references
#
#  id                   :integer          not null, primary key
#  first_name           :string
#  last_name            :string
#  phone_number         :string
#  created_at           :datetime         not null
#  updated_at           :datetime         not null
#  lease_application_id :integer
#  city                 :string
#  state                :string
#  phone_number_line    :string
#  phone_number_carrier :string
#
# Indexes
#
#  index_references_on_lease_application_id  (lease_application_id)
#
# Foreign Keys
#
#  fk_rails_...  (lease_application_id => lease_applications.id)
#

class Reference < ApplicationRecord
  belongs_to :lease_application

  validates :first_name,   presence: true
  validates :last_name,    presence: true
  validates :phone_number, presence: true
  validates :city,         presence: true
  validates :state,        presence: true

  def full_name
    [first_name, last_name].reject(&:blank?).join(" ")
  end

  before_save :validate_phone, if: :phone_number_changed?

  private

  def valid_phone?
    number_service.valid? && number_service.carrier_lookup['error_code'].nil?
  end

  def validate_phone
    if valid_phone?
      update_carrier_info
    else
      clear_carrier_info
    end
  end

  def update_carrier_info
    carrier_data = number_service.carrier_lookup
    self.phone_number_line = carrier_data['type']
    self.phone_number_carrier = carrier_data['name']
  end

  def clear_carrier_info
    self.phone_number_line = nil
    self.phone_number_carrier = nil
  end

  def number_service
    @service ||= PhoneNumberServices.new(phone_number)
  end
end

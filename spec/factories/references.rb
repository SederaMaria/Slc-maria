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

FactoryBot.define do
  factory :reference do
    first_name { FFaker::Name.first_name }
    last_name { FFaker::Name.last_name }
    phone_number { FFaker::PhoneNumber.phone_number }
    lease_application
    city { FFaker::AddressUS.city }
    state { FFaker::AddressUS.state }
  end
end

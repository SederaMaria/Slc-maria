# == Schema Information
#
# Table name: dealerships
#
#  id                      :integer          not null, primary key
#  name                    :string
#  website                 :string
#  primary_contact_phone   :string
#  created_at              :datetime         not null
#  updated_at              :datetime         not null
#  state                   :string           not null
#  franchised              :boolean
#  franchised_new_makes    :boolean
#  legal_corporate_entity  :string
#  dealer_group            :string
#  active                  :boolean
#  address_id              :integer
#  agreement_signed_on     :date
#  executed_by_name        :string
#  executed_by_title       :string
#  executed_by_slc_on      :date
#  los_access_date         :date
#  notes                   :text
#  use_experian            :boolean          default(TRUE), not null
#  use_equifax             :boolean          default(FALSE), not null
#  use_transunion          :boolean          default(TRUE), not null
#  access_id               :integer
#  bank_name               :string
#  account_number          :bigint(8)
#  routing_number          :string
#  account_type            :integer
#  security_deposit        :integer          default(0), not null
#  enable_security_deposit :boolean          default(FALSE)
#  can_submit              :boolean          default(FALSE)
#  can_see_banner          :boolean          default(TRUE)
#
# Indexes
#
#  index_dealerships_on_address_id  (address_id)
#
# Foreign Keys
#
#  fk_rails_...  (address_id => addresses.id)
#

FactoryBot.define do
  factory :dealership do
    address
    
    name                  { FFaker::Company.name }
    website               { FFaker::Internet.http_url }
    primary_contact_phone { FFaker::PhoneNumber.phone_number }
    state                 { 'FL' }
  end

  trait :with_3_dealers do
    after(:create) do |obj|
      3.times { obj.dealers << create(:dealer) }
    end
  end
end

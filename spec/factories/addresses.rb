# == Schema Information
#
# Table name: addresses
#
#  id         :integer          not null, primary key
#  street1    :string
#  street2    :string
#  city       :string
#  state      :string
#  zipcode    :string
#  created_at :datetime         not null
#  updated_at :datetime         not null
#  county     :string
#

FactoryBot.define do
  factory :address do
    street1 { '123 Piedmont St' }
    street2 { '204'}
    city { 'Atlanta' }
    county { 'Broward' }
    state { 'FL' } #matches lease calculator's florida default
    zipcode { '30342' }

    trait :empty do
      street1 { nil }
      city { nil }
      state { nil }
      zipcode { nil }
    end

    trait :employment_only do
      street1 { nil }
      city { "Atlanta" }
      state { "FL" } #matches lease calculator's florida default
      zipcode { nil }
    end
  end
end
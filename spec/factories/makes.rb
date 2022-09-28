# == Schema Information
#
# Table name: makes
#
#  id              :integer          not null, primary key
#  name            :string
#  vin_starts_with :string
#  created_at      :datetime         not null
#  updated_at      :datetime         not null
#  lms_manf        :string(10)
#  nada_enabled    :boolean          default(FALSE)
#  active          :boolean          default(TRUE)
#

FactoryBot.define do
  factory :make do
    name            { FFaker::Vehicle.make }
    vin_starts_with { FFaker::Vehicle.vin[0..2] }

    trait :for_harley_davidson do
      name { Make::HARLEY_DAVIDSON }
      vin_starts_with { '1HD' }
      lms_manf        { 'HARLEY-DAV' }
    end
  end
end

# == Schema Information
#
# Table name: counties
#
#  id              :bigint(8)        not null, primary key
#  us_state_id     :integer
#  name            :string
#  abbreviation    :string
#  created_at      :datetime         not null
#  updated_at      :datetime         not null
#  geo_code_county :string(3)
#

FactoryBot.define do
  factory :county do
    state_id { 1 }
    name { "MyString" }
    abbreviation { "MyString" }
  end
end

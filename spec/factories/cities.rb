# == Schema Information
#
# Table name: cities
#
#  id             :bigint(8)        not null, primary key
#  name           :string
#  county_id      :integer
#  created_at     :datetime         not null
#  updated_at     :datetime         not null
#  city_zip_begin :string
#  city_zip_end   :string
#  geo_state      :string
#  geo_county     :string
#  geo_city       :string
#  us_state_id    :integer
#

FactoryBot.define do
  factory :city do
    name { "MyString" }
    county_id { 1 }
    zipcode { "MyString" }
    abbrevation { "MyString" }
  end
end

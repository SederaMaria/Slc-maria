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

class City < ApplicationRecord
  belongs_to :county
  belongs_to :us_state
  has_many :lease_applications, dependent: :destroy
end

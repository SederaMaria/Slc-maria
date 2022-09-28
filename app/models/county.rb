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

class County < ApplicationRecord
  belongs_to :us_state, foreign_key: :us_state_id

  has_many :cities, dependent: :destroy, foreign_key: :county_id
end

# == Schema Information
#
# Table name: police_bike_rules
#
#  id                         :bigint(8)        not null, primary key
#  proxy_model_make           :integer
#  proxy_model_name           :string
#  new_model_make             :integer
#  new_model_name             :string
#  proxy_rough_value_percent  :decimal(10, 2)
#  proxy_retail_value_percent :decimal(10, 2)
#  created_at                 :datetime         not null
#  updated_at                 :datetime         not null
#  starting_proxy_year        :integer          default(2017), not null
#


class PoliceBikeRule < ApplicationRecord
	belongs_to :make
	validates :proxy_rough_value_percent, presence: true, format: { with: /\A\d+(?:\.\d{0,2})?\z/ }, numericality: { greater_than: 0, less_than_or_equal_to: 100 }
	validates :proxy_retail_value_percent, presence: true, format: { with: /\A\d+(?:\.\d{0,2})?\z/ }, numericality: { greater_than: 0, less_than_or_equal_to: 100 }
end

# == Schema Information
#
# Table name: vertex_extracts
#
#  id             :bigint(8)        not null, primary key
#  record_type    :string
#  geocode_state  :string
#  geocode_county :string
#  geocode_city   :string
#  zip_start      :string
#  zip_end        :string
#  sales_tax_rate :string
#  created_at     :datetime         not null
#  updated_at     :datetime         not null
#

FactoryBot.define do
  factory :vertex_extract do
    
  end
end

# == Schema Information
#
# Table name: tax_details
#
#  id                                    :bigint(8)        not null, primary key
#  geo_code                              :string
#  geocode_city                          :string
#  geocode_state                         :string
#  geocode_county                        :string
#  zipcode                               :string
#  vertex_statistics_id                  :integer
#  tax_juridication_id                   :integer
#  tax_rule_id                           :integer
#  county_tax_rule_id                    :integer
#  city_tax_rule_id                      :integer
#  state_tax_rule_id                     :integer
#  county_id                             :integer
#  city_id                               :integer
#  state_rental_tax_rate                 :string(6)
#  state_rental_tax_rate_effective_date  :string(6)
#  state_sales_tax_rate                  :string(6)
#  state_sales_tax_rate_effective_date   :string(6)
#  state_use_tax_rate                    :string(6)
#  state_use_tax_rate_effective_date     :string(6)
#  county_sales_tax_rate                 :string(6)
#  county_sales_tax_rate_effective_date  :string(6)
#  county_use_tax_rate                   :string(6)
#  county_use_tax_rate_effective_date    :string(6)
#  county_rental_tax_rate                :string(6)
#  county_rental_tax_rate_effective_date :string(6)
#  city_sales_tax_rate                   :string(6)
#  city_sales_tax_rate_effective_date    :string(6)
#  city_use_tax_rate                     :string(6)
#  city_use_tax_rate_effective_date      :string(6)
#  city_rental_tax_rate                  :string(6)
#  city_rental_tax_rate_effective_date   :string(6)
#  city_zip_begin                        :string(9)
#  city_zip_end                          :string(9)
#  rule_type                             :integer
#  created_at                            :datetime         not null
#  updated_at                            :datetime         not null
#  lease_application_id                  :integer
#  us_state_id                           :bigint(8)
#

FactoryBot.define do
  factory :tax_detail do
    geo_code { "MyString" }
    geo_code_city { "MyString" }
    geo_code_state { "MyString" }
    geo_code_county { "MyString" }
    zipcode { "MyString" }
    vertex_statistics_id { 1 }
    tax_juridication_id { 1 }
    tax_rule_id { 1 }
    county_tax_rule_id { 1 }
    city_tax_rule { 1 }
    state_tax_rule { 1 }
    state_id { 1 }
    county_id { 1 }
    city_id { 1 }
  end
end

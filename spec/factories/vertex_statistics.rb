# == Schema Information
#
# Table name: vertex_statistics
#
#  id                                    :bigint(8)        not null, primary key
#  geo_code                              :string(9)
#  geo_state                             :string(2)
#  geo_county                            :string(3)
#  geo_city                              :string(4)
#  state_change_indicator                :string(1)
#  state_description                     :string(20)
#  state_sales_tax_rate                  :string(6)
#  state_sales_tax_rate_effective_date   :string(6)
#  state_user_tax_rate                   :string(6)
#  state_user_tax_rate_effective_date    :string(6)
#  state_rental_tax_rate                 :string(6)
#  state_rental_tax_rate_effective_date  :string(6)
#  county_change_indicator               :string(1)
#  county_description                    :string(20)
#  county_sales_tax_rate                 :string(6)
#  county_sales_tax_rate_effective_date  :string(6)
#  county_user_tax_rate                  :string(6)
#  county_user_tax_rate_effective_date   :string(6)
#  county_rental_tax_rate                :string(6)
#  county_rental_tax_rate_effective_date :string(6)
#  city_change_indicator                 :string(1)
#  city_description                      :string(25)
#  city_sales_tax_rate                   :string(6)
#  city_sales_tax_rate_effective_date    :string(6)
#  city_user_tax_rate                    :string(6)
#  city_user_tax_rate_effective_date     :string(6)
#  city_rental_tax_rate                  :string(6)
#  city_rental_tax_rate_effective_date   :string(6)
#  city_zip_begin                        :string(9)
#  city_zip_end                          :string(9)
#  last_changed_date                     :string(6)
#  update_number                         :string(3)
#  vertex_file_id                        :bigint(8)
#  created_at                            :datetime         not null
#  updated_at                            :datetime         not null
#
# Indexes
#
#  index_vertex_statistics_on_vertex_file_id  (vertex_file_id)
#
# Foreign Keys
#
#  fk_rails_...  (vertex_file_id => vertex_files.id)
#

FactoryBot.define do
  factory :vertex_statistic do
    geo_code { "MyString" }
    geo_state { "MyString" }
    geo_county { "MyString" }
    geo_city { "MyString" }
    state_change_indicator { "MyString" }
    state_description { "MyString" }
    state_sales_tax_rate { "MyString" }
    state_sales_tax_rate_effective_date { "MyString" }
    state_user_tax_rate { "MyString" }
    state_user_tax_rate_effective_date { "MyString" }
    state_rental_tax_rate { "MyString" }
    state_rental_tax_rate_effective_date { "MyString" }
    county_change_indicator { "MyString" }
    county_description { "MyString" }
    county_sales_tax_rate { "MyString" }
    county_sales_tax_rate_effective_date { "MyString" }
    county_user_tax_rate { "MyString" }
    county_user_tax_rate_effective_date { "MyString" }
    county_rental_tax_rate { "MyString" }
    county_rental_tax_rate_effective_date { "MyString" }
    city_change_indicator { "MyString" }
    city_description { "MyString" }
    city_sales_tax_rate { "MyString" }
    city_sales_tax_rate_effective_date { "MyString" }
    city_user_tax_rate { "MyString" }
    city_user_tax_rate_effective_date { "MyString" }
    city_rental_tax_rate { "MyString" }
    city_rental_tax_rate_effective_date { "MyString" }
    city_zip_begin { "MyString" }
    city_zip_end { "MyString" }
    last_changed_date { "MyString" }
    update_number { "MyString" }
    vertex_file { nil }
  end
end

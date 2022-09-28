# == Schema Information
#
# Table name: tax_jurisdictions
#
#  id                      :integer          not null, primary key
#  name                    :string
#  us_state                :integer
#  state_tax_rule_id       :integer
#  county_tax_rule_id      :integer
#  local_tax_rule_id       :integer
#  created_at              :datetime         not null
#  updated_at              :datetime         not null
#  geo_code                :string(9)
#  geo_code_state          :string
#  geo_code_county         :string
#  geo_code_city           :string
#  effective_date          :date
#  tax_record_types_id     :bigint(8)
#  jurisdiction_name       :string(100)
#  zip_code_start          :string(10)
#  zip_code_end            :string(10)
#  ignore_sales_tax_engine :boolean          default(FALSE)
#  us_states_id            :bigint(8)
#
# Indexes
#
#  index_jurisdiction_on_most_to_least_specific_region  (local_tax_rule_id,county_tax_rule_id,state_tax_rule_id,us_state)
#  index_tax_jurisdictions_on_name_and_us_state         (name,us_state) UNIQUE
#  index_tax_jurisdictions_on_tax_record_types_id       (tax_record_types_id)
#  index_tax_jurisdictions_on_us_states_id              (us_states_id)
#
# Foreign Keys
#
#  fk_rails_...  (tax_record_types_id => tax_record_types.id)
#  fk_rails_...  (us_states_id => us_states.id)
#

FactoryBot.define do
  factory :tax_jurisdiction do
    state_tax_rule factory: [:tax_rule, :state_rule]
    county_tax_rule factory: [:tax_rule, :county_rule]
    local_tax_rule factory: [:tax_rule, :local_rule]

    sequence(:name) { |n| "#{FFaker::Name.name} #{n}" }
    us_state { :florida }
  end
end

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

class TaxJurisdiction < ApplicationRecord

  ## All 50 states + DC
  enum(us_state: { delaware: 1, pennsylvania: 2, new_jersey: 3, georgia: 4, connecticut: 5, massachusetts: 6,
                   maryland: 7, south_carolina: 8, new_hampshire: 9, virginia: 10, new_york: 11, 
                   north_carolina: 12, rhode_island: 13, vermont: 14, kentucky: 15, tennessee: 16,
                   ohio: 17, louisiana: 18, indiana: 19, mississippi: 20, illinois: 21, alabama: 22,
                   maine: 23, missouri: 24, arkansas: 25, michigan: 26, florida: 27, texas: 28,
                   iowa: 29, wisconsin: 30, california: 31, minnesota: 32, oregon: 33, kansas: 34,
                   west_virginia: 35, nevada: 36, nebraska: 37, colorado: 38, north_dakota: 39,
                   south_dakota: 40, montana: 41, washington: 42, idaho: 43, wyoming: 44, utah: 45, 
                   oklahoma: 46, new_mexico: 47, arizona: 48, alaska: 49, hawaii: 50, district_of_columbia: 51 },
      _prefix: 'in')
  
  belongs_to :state_tax_rule, class_name: 'TaxRule'
  belongs_to :county_tax_rule, class_name: 'TaxRule'
  belongs_to :local_tax_rule, class_name: 'TaxRule'

  validates :name, :us_state, presence: true
  validates :name, uniqueness: { scope: :us_state }

  def state_upfront_tax_percentage
    state_tax_rule&.up_front_tax_percentage || 0.0
  end

  def county_upfront_tax_percentage
    county_tax_rule&.up_front_tax_percentage || 0.0
  end

  def local_upfront_tax_percentage
    local_tax_rule&.up_front_tax_percentage || 0.0
  end

  def total_sales_tax_percentage
    return 0 if state_tax_rule_id.nil? && county_tax_rule_id.nil? && local_tax_rule_id.nil?
    TaxRule.where(id: [state_tax_rule_id, county_tax_rule_id, local_tax_rule_id].compact).sum(:sales_tax_percentage)
  end

end

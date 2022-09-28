# == Schema Information
#
# Table name: tax_rules
#
#  id                       :integer          not null, primary key
#  name                     :string
#  sales_tax_percentage     :decimal(6, 4)    default(0.0)
#  up_front_tax_percentage  :decimal(6, 4)    default(0.0)
#  cash_down_tax_percentage :decimal(6, 4)    default(0.0)
#  rule_type                :integer
#  created_at               :datetime         not null
#  updated_at               :datetime         not null
#  effective_date           :date
#  prior_rate               :decimal(, )
#  tax_jurisdictions_id     :bigint(8)
#  end_date                 :date             default(Tue, 31 Dec 2999)
#  notes                    :string(100)
#
# Indexes
#
#  index_tax_rules_on_name                  (name) UNIQUE
#  index_tax_rules_on_tax_jurisdictions_id  (tax_jurisdictions_id)
#
# Foreign Keys
#
#  fk_rails_...  (tax_jurisdictions_id => tax_jurisdictions.id)
#

class TaxRule < ApplicationRecord
  enum rule_type: { state: 0, county: 1, local: 2 }

  has_many :tax_jurisdictions, 
    ->(tax_rule) { 
      unscope(:where).
      where("#{self.quoted_table_name}.state_tax_rule_id = :id OR \
             #{self.quoted_table_name}.county_tax_rule_id = :id OR \
             #{self.quoted_table_name}.local_tax_rule_id = :id", id: tax_rule.id)
    }

  scope :by_tax_jurisdiction, ->(id) { joins("JOIN tax_jurisdictions as tj on tax_rules.id = tj.state_tax_rule_id or tax_rules.id = tj.county_tax_rule_id or  tax_rules.id = tj.local_tax_rule_id WHERE tj.id = #{id}") }

  validates :name, presence: true, uniqueness: true

  validates :sales_tax_percentage, :up_front_tax_percentage, :cash_down_tax_percentage,
    numericality: { greater_than_or_equal_to: 0, less_than_or_equal_to: 100,  message: 'must be between 0% & 100%' }
    
  def self.ransackable_scopes(_auth_object = nil)
    %i[by_tax_jurisdiction]
  end
  
end

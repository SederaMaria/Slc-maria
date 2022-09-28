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

FactoryBot.define do
  factory :tax_rule do
    name { FFaker::Address.city }
    sales_tax_percentage { 0 }
    up_front_tax_percentage { 0 }
    cash_down_tax_percentage { 0 }
    rule_type { :local }

    trait(:state_rule) do
      rule_type { :state }
    end

    trait(:county_rule) do
      rule_type { :county }
    end

    trait(:local_rule) do
      rule_type { :local }
    end
  end
end

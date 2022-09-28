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

require 'rails_helper'

RSpec.describe TaxRule, type: :model do
  pending "add some examples to (or delete) #{__FILE__}"
end

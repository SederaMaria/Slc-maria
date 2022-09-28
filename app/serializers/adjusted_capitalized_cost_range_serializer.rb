# == Schema Information
#
# Table name: adjusted_capitalized_cost_ranges
#
#  id                            :bigint(8)        not null, primary key
#  acquisition_fee_cents         :integer
#  adjusted_cap_cost_lower_limit :integer
#  adjusted_cap_cost_upper_limit :integer
#  credit_tier_id                :bigint(8)
#  effective_date                :datetime
#  end_date                      :datetime
#  created_at                    :datetime         not null
#  updated_at                    :datetime         not null
#
# Indexes
#
#  index_adjusted_capitalized_cost_ranges_on_credit_tier_id  (credit_tier_id)
#
# Foreign Keys
#
#  fk_rails_...  (credit_tier_id => credit_tiers.id)
#

class AdjustedCapitalizedCostRangeSerializer < ApplicationSerializer
  attributes :id, :acquisition_fee_cents, :adjusted_cap_cost_lower_limit, :adjusted_cap_cost_upper_limit, :credit_tier_id
end

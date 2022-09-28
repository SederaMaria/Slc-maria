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

class AdjustedCapitalizedCostRange < ApplicationRecord
  belongs_to :credit_tier

  scope :order_by_credit_tier_and_lower_limit, -> { order(credit_tier_id: :asc, adjusted_cap_cost_lower_limit: :asc) }

  #monetize all _cents fields with a couple of lines
  if table_exists?
    self.column_names.each { |col| monetize(col) if col.ends_with?('_cents') }
  end

  def self.make_credit_tiers
    where("credit_tier_id IN (?)", @make.credit_tier_ids).order(:credit_tier_id)
  end

end

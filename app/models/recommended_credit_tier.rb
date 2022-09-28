# == Schema Information
#
# Table name: recommended_credit_tiers
#
#  id                                    :bigint(8)        not null, primary key
#  lessee_id                             :integer
#  credit_tier_id                        :integer
#  credit_report_id                      :integer
#  recommended_credit_tier               :integer
#  created_at                            :datetime         not null
#  updated_at                            :datetime         not null
#  lease_application_blackbox_request_id :integer
#

class RecommendedCreditTier < ApplicationRecord
  belongs_to :credit_tier
  belongs_to :credit_report
  belongs_to :lease_application_blackbox_request
end

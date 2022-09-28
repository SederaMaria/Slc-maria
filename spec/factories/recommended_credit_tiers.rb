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

FactoryBot.define do
  factory :recommended_credit_tier do
    credit_tier_id { 1 }
  end
end

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

require 'rails_helper'

RSpec.describe RecommendedCreditTier, type: :model do
  it { should belong_to(:credit_tier) }
  it { should belong_to(:credit_report) }
  it { should belong_to(:lease_application_blackbox_request) }

  it "creates correctly" do
    record = create(:recommended_credit_tier)
    expect(record).to be_valid
    expect(record).to be_persisted
  end
end

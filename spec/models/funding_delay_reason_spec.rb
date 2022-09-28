# == Schema Information
#
# Table name: funding_delay_reasons
#
#  id         :bigint(8)        not null, primary key
#  reason     :string
#  created_at :datetime         not null
#  updated_at :datetime         not null
#  active     :boolean          default(TRUE)
#

require 'rails_helper'

RSpec.describe FundingDelayReason, type: :model do
  it "creates correctly" do
    fdr = create(:funding_delay_reason)
    expect(fdr).to be_valid
    expect(fdr).to be_persisted
    expect(fdr.reason).to be_present
  end
end

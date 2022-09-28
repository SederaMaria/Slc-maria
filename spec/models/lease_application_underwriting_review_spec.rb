require 'rails_helper'

RSpec.describe LeaseApplicationUnderwritingReview, type: :model do
  it { should belong_to(:lease_application) }
  it { should belong_to(:admin_user) }
  it { should belong_to(:workflow_status) }

  it 'creates correctly' do
    record = create(:lease_application_underwriting_review)
    expect(record).to be_valid
    expect(record).to be_persisted
  end
end

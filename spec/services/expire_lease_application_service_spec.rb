require 'rails_helper'

RSpec.describe ExpireLeaseApplicationService do
  subject { described_class.new().expire! }
  let(:application){create(:lease_application, credit_status: 'awaiting_credit_decision', submitted_at: 31.day.ago)}
  context 'Expire to submitted application' do
    it 'Expired application' do
      expect { subject }.to change { application.reload.expired }.from(false).to(true)
    end
  end
end

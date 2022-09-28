require 'rails_helper'

RSpec.describe Dealers::LeaseApplicationFacade do
  subject { described_class.new(lease_application: application, dealer: dealer) }

  describe '#rescind_application!' do
    let(:application) do 
      app = create(:lease_application) 
      app.dealership.dealers << create(:dealer)
      app
    end
    let(:dealer) { nil }
    it 'rescinds application' do
      expect { subject.rescind_application! }.to change{ application.credit_status }.from("unsubmitted").to("rescinded")
    end

    it 'notifies dealers of changed status' do
      expect { subject.rescind_application! }.to change(CreditDecisionNotificationJob.jobs, :size).by(1)
    end
  end

  describe '#submit_application!' do
    let(:application) { build(:lease_application) }
    let(:dealer) { nil }
    it 'invokes LeaseApplicationSubmitterService' do
      expect_any_instance_of(LeaseApplicationSubmitterService).to receive(:submit!)
      subject.submit_application!
    end
  end

  describe '#swap lessee!' do
    let(:application) { build(:lease_application) }
    let(:dealer) { nil }
    it 'invokes LesseeAndColesseeSwapper' do
      expect_any_instance_of(LesseeAndColesseeSwapper).to receive(:swap!)
      subject.swap_lessee!
    end
  end

  describe '#build_app' do
    let(:application) { nil }
    let(:dealer)      { nil }
    let(:new_application) { LeaseApplication.new(lessee: Lessee.new, colessee: Lessee.new) }
    it 'returns new lease application with new lessee and colessee' do
      expect(subject.build_app).to be_an_instance_of(LeaseApplication)
    end
  end
end

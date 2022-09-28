require 'rails_helper'

RSpec.describe ColesseeRemover do
  subject { described_class.new(application).remove_colessee! }

  context 'when lease application has a colessee' do
    let!(:application) { create(:lease_application) }
    let!(:lessee)      { application.lessee }
    let!(:colessee)    { application.colessee }
    

    it { is_expected.to be_truthy }
    
    it 'makes the colessee nil' do
      expect { subject }.to change { application.colessee }.from(colessee).to(nil)
    end

    it 'does nothing to the lessee' do
      expect { subject }.to_not change { application.lessee_id }
    end

    it 'does nothing to the lessee ID' do
      expect { subject }.to_not change { application.lessee }
    end

    it 'makes the colessee ID nil' do
      expect { subject }.to change { application.colessee_id }.from(colessee.id).to(nil)
    end

    it 'does not delete any Lessee Records' do
      expect { subject }.to_not change(Lessee, :count)
    end

    it 'moves the Lessee record to the Deleted Colessees collection - preserving the original record' do
      subject
      expect(application.deleted_colessees).to eq([colessee])
    end

    it 'should email notify admins' do
      message_delivery = instance_double(ActionMailer::MessageDelivery)
      expect(DealerMailer).to receive(:dealer_removed_colessee).with(application: application, colessee: colessee).and_return(message_delivery)
      allow(message_delivery).to receive(:deliver_now)
      subject
    end
    context "if the application is submitted already" do
      let(:application) { create(:lease_application, :submitted, :approved_with_contingencies) }
      it 'changes the application back to awaiting credit decision' do
        expect { subject }.to change { application.credit_status }.from("approved_with_contingencies").to("awaiting_credit_decision")
      end
    end

    context "if the application is not submitted yet" do
      it 'remains unsubmitted' do
        expect { subject }.to_not change { application.credit_status }
      end
    end
  end

  context 'when lease application has no colessee' do
    let(:application) { create(:lease_application, colessee: nil) }
    it 'does not remove the colessee' do
      expect { subject }.not_to change { application.lessee }
    end
    it 'does not perform swap' do
      expect { subject }.not_to change { application.colessee }
    end
    it { is_expected.to be_falsey }
  end
end

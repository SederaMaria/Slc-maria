require 'rails_helper'

RSpec.describe LesseeAndColesseeSwapper do
  subject { described_class.new(lease_application: application).swap! }

  context 'when lease application has both lessee and colessee' do
    let(:application) { create(:lease_application) }
    let(:lessee)      { application.lessee }
    let(:colessee)    { application.colessee }
    it 'makes the lessee the colessee' do
      expect { subject }.to change { application.lessee }.from(lessee).to(colessee)
    end

    it 'makes the colessee the lessee' do
      expect { subject }.to change { application.colessee }.from(colessee).to(lessee)
    end

    it 'makes the lessee ID the colessee ID' do
      expect { subject }.to change { application.lessee_id }.from(lessee.id).to(colessee.id)
    end

    it 'makes the colessee ID the lessee ID' do
      expect { subject }.to change { application.colessee_id }.from(colessee.id).to(lessee.id)
    end
    it { is_expected.to be_truthy }
  end

  context 'when lease application has only one lessee' do
    let(:application) { create(:lease_application, colessee: nil) }
    it 'does not perform swap' do
      expect { subject }.not_to change { application.lessee }
    end
    it 'does not perform swap' do
      expect { subject }.not_to change { application.colessee }
    end
    it { is_expected.to be_falsey }
  end

  context 'when lease application has only one lessee' do
    let(:application) { create(:lease_application, lessee: nil, colessee: nil) }
    it 'does not perform swap' do
      expect { subject }.not_to change { application.lessee }
    end
    it 'does not perform swap' do
      expect { subject }.not_to change { application.colessee }
    end
    it { is_expected.to be_falsey }
  end
end

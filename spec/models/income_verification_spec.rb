require 'rails_helper'

RSpec.describe IncomeVerification, type: :model do
  it { should belong_to(:lessee) }
  it { should belong_to(:income_verification_type) }
  it { should belong_to(:income_frequency) }
  it { should belong_to(:lease_application_attachment) }
  it { should belong_to(:created_by_admin) }
  it { should belong_to(:updated_by_admin) }

  it 'creates correctly' do
    record = create(:income_verification)
    expect(record).to be_valid
    expect(record).to be_persisted
  end
end

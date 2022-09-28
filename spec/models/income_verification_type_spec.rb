require 'rails_helper'

RSpec.describe IncomeVerificationType, type: :model do
  it 'creates correctly' do
    record = create(:income_verification_type)
    expect(record).to be_valid
    expect(record).to be_persisted
  end
end

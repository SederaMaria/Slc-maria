require 'rails_helper'

RSpec.describe IncomeFrequency, type: :model do
  it 'creates correctly' do
    record = create(:income_frequency)
    expect(record).to be_valid
    expect(record).to be_persisted
  end
end

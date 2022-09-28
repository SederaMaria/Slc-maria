require 'rails_helper'

RSpec.describe StipulationCreditTier, type: :model do
  it { should belong_to(:stipulation) }
  it { should belong_to(:stipulation_credit_tier_type) }
end

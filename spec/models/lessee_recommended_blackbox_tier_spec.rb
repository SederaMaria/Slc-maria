require 'rails_helper'

RSpec.describe LesseeRecommendedBlackboxTier, type: :model do

  describe '#associations' do
    it 'associations' do
      should belong_to :lessee
      should belong_to :blackbox_model_detail
      should belong_to :lease_application_blackbox_request
    end
  end

end

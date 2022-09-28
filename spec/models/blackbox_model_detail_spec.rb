require 'rails_helper'

RSpec.describe BlackboxModelDetail, type: :model do

  describe '#associations' do
    it 'associations' do
      should belong_to :blackbox_model
    end
  end

end

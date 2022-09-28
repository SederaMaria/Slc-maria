require 'rails_helper'

RSpec.describe RemoveDeadApplications, type: :service  do
  describe '#call' do
    it 'destroys all dead applications' do
      dead_applications_collection = double(destroy_all: true)
      expect(LeaseApplication).to receive(:dead_applications).and_return(dead_applications_collection)
      expect(dead_applications_collection).to receive(:destroy_all).and_return(true)
      RemoveDeadApplications.call
    end
  end
end

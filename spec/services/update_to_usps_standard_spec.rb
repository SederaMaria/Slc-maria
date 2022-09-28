require 'rails_helper'
=begin
RSpec.describe UpdateToUspsStandard, type: :service do
  describe '#call' do
    it 'updates address to USPS standard' do
      VCR.use_cassette('smarty-streets/single-success', match_requests_on: [:host, :path]) do
        address = create(:address, street1: '123 Peachtree Street ', city: 'Atlanta', state: 'GA', 'zipcode': '30303')

        UpdateToUspsStandard.call(address)

        expect(address.reload.street1).to eq '123 PEACHTREE ST NE'
        expect(address.reload.zipcode).to eq '30303-1803'
        expect(address.reload.city).to eq 'ATLANTA'
        expect(address.reload.state).to eq 'GA'
        expect(address.reload.county).to eq 'FULTON'
      end
    end
  end
end
=end
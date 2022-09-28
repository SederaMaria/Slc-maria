require 'rails_helper'

RSpec.describe MultipleAddressesValidator, type: :service do
  subject { described_class.new(addresses).call }

  context 'when provided addresses are valid' do
    let(:addresses) do
      [
        {:street=>"123 Peachtree Street ", :city=>"Atlanta", :state=>"GA", :zipcode=>"30303"},
        {:street=>"PO BOX 1234 ", :city=>"Atlanta", :state=>"GA", :zipcode=>"30303"},
        {:street=>"3525 Piedmont Road Suite 5-205", :city=>"Atlanta", :state=>"GA", :zipcode=>"30305"}
      ]
    end

    it 'returns validation result', :vcr do
      VCR.use_cassette('smarty-streets/success', match_requests_on: [:host, :path]) do
        expect(subject).to eq [true, true, true]
      end
    end
  end

  context 'when one of addresses is invalid' do
    let(:addresses) do
      [
        {:street=>"123 Peachtree Street ", :city=>"Atlanta", :state=>"GA", :zipcode=>"30303"},
        {:street=>"PO BOX 1234 ", :city=>"Atlanta", :state=>"GA", :zipcode=>"30303"},
        {:street=>"some", :city=>"invalid", :state=>"address", :zipcode=>"30305"}
      ]
    end

    it 'returns validation result', :vcr do
      VCR.use_cassette('smarty-streets/one-invalid', match_requests_on: [:host, :path]) do
        expect(subject).to eq [true, true, false]
      end
    end
  end

  context 'when all of addresses are invalid' do
    let(:addresses) do
      [
        {:street=>"some 1", :city=>"invalid 1", :state=>"address 1", :zipcode=>"30303"},
        {:street=>"some 2", :city=>"invalid 2", :state=>"address 2", :zipcode=>"30303"},
        {:street=>"some 3", :city=>"invalid 3", :state=>"address 3", :zipcode=>"30305"}
      ]
    end

    it 'returns validation result', :vcr do
      VCR.use_cassette('smarty-streets/all-invalid', match_requests_on: [:host, :path]) do
        expect(subject).to eq [false, false, false]
      end
    end
  end
end

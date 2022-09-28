require 'rails_helper'

RSpec.describe PhoneNumberServices, type: :service do
  subject { described_class.new(number) }
  let(:number) { '+14159341234' }

  context 'validation' do
    describe 'when given phone number is valid' do
      it 'returns true', :vcr do
        VCR.use_cassette('twilio/phone_valid', match_requests_on: [:host, :path]) do
          expect(subject.valid?).to be_truthy
        end
      end
    end

    describe 'when given phone number is invalid' do
      let(:number) { '+1234567890' }

      it 'returns false', :vcr do
        VCR.use_cassette('twilio/phone_invalid', match_requests_on: [:host, :path]) do
          expect(subject.valid?).to be_falsey
        end
      end

      it "contains an error message" do
        VCR.use_cassette('twilio/phone_invalid', match_requests_on: [:host, :path]) do
          subject.valid?
          expect(subject.error_message).to eq("The requested resource /PhoneNumbers/+1234567890 was not found")
        end
      end
    end

    describe 'when the given phone number is blank' do
      let(:number) { '' }

      it 'returns false' do
        expect(subject.valid?).to be_falsey
      end
    end
  end

  context 'lookups' do
    describe 'carrier lookup for a valid phone' do
      let(:expected_carrier) do
        {
          name: 'Pacific Bell',
          type: 'landline'
        }
      end

      it 'returns the carrier info', :vcr do
        VCR.use_cassette('twilio/phone_carrier', match_requests_on: [:host, :path]) do
          expect(subject.carrier_lookup['name']).to eql(expected_carrier[:name])
          expect(subject.carrier_lookup['type']).to eql(expected_carrier[:type])
        end
      end
    end
  end
end

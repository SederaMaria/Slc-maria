require 'rails_helper'

RSpec.describe ValidatePhoneJob, type: :job do
  subject { described_class.new.perform(lease_validation.id) }
  let(:lessee) { create(:lessee, :with_valid_phone_numbers) }
  let!(:lease_validation) { create(:home_phone_validation, validatable: lessee) }

  describe 'validation' do
    context 'is valid?' do
      it 'should save the validation as valid' do
        VCR.use_cassette('twilio/phone_valid', match_requests_on: [:host, :path]) do
          expect{ subject }.to change{ lease_validation.reload.status }.to 'status_valid'
        end
      end

      it 'should update carrier details' do
        VCR.use_cassette('twilio/phone_valid', match_requests_on: [:host, :path]) do
          VCR.use_cassette('twilio/carrier_lookup', match_requests_on: [:host, :path]) do
            expect{ subject }.to change{ lessee.reload.home_phone_number_line }.to 'MOBILE'
          end
        end
      end
    end

    context 'is invalid?' do
      let(:lessee) { create(:lessee) }

      it 'should save the validation as invalid' do
        VCR.use_cassette('twilio/phone_invalid', match_requests_on: [:host, :path]) do
          expect{ subject }.to change{ lease_validation.reload.status }.to 'status_invalid'
        end
      end
    end
  end
end

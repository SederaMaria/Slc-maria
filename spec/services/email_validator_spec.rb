require 'rails_helper'

#See https://docs.kickbox.io/docs/sandbox-api for test email addresses
RSpec.describe EmailValidator, type: :service do
  subject { described_class.new(email).valid? }

  context 'when given email is valid' do
    let(:email) { 'deliverable@example.com' }

    it 'returns true', :vcr do
      VCR.use_cassette('kickbox/email_valid', match_requests_on: [:path, :body]) do
        expect(subject).to be true
      end
    end
  end

  context 'when given email is invalid' do
    let(:email) { 'invalid-email@example.com' }

    it 'returns false', :vcr do
      VCR.use_cassette('kickbox/email_invalid', match_requests_on: [:path, :body]) do
        expect(subject).to be false
      end
    end
  end
end


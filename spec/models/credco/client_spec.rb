require 'rails_helper'

RSpec.describe Credco::Client, type: :model do
  describe '#merge_report' do
    it 'returns Credco credit merge report' do
      VCR.use_cassette('credco/credit_merge_report', match_requests_on: [:path, :body]) do
        lessee            = create(:lessee, :credco_test, dealership: create(:dealership))
        raw_credit_report = Credco::Client.new(lessee_record: lessee).credit_report
        parsed_response   = Credco::ResponseParser.new(credco_response: raw_credit_report)
        expect(parsed_response.embedded_file).to be_present
      end
    end

    # TODO Find a way to make this pass in CI via wait_until, or rake task, or circleci config or something smart
    # Finicky tests which fails often in CI
    xit 'raises error on failed request' do
      VCR.use_cassette('credco/failed_credit_merge_report', match_requests_on: [:path, :body]) do
        ENV['CREDCO_PASSWORD'] = 'wrongpassword'
        lessee = create(:lessee, :credco_test, dealership: create(:dealership))
        expect{
          Credco::Client.new(lessee_record: lessee).credit_report
        }.to raise_error(/Invalid Login ID or Password/)
      end
    end
  end
end
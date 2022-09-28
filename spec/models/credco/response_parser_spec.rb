# class Credco::ResponseParser

#   attr_reader :xml_response

#   def initialize(credco_response:)
#     @xml_response = Nokogiri::XML.parse(credco_response)
#   end
 
#   def has_embedded_file?
#     embedded_file.present?
#   end

#   def decode_and_return_embedded_file
#     Base64.decode64(embedded_file.first.text) if has_embedded_file?
#   end
  
#   #A Single XPATH search can replace this whole thing
#   def embedded_file
#     @xml_response.xpath("//RESPONSE_GROUP//RESPONSE//RESPONSE_DATA//CREDIT_RESPONSE//EMBEDDED_FILE//DOCUMENT")
#   end

#   def generate_credit_report_pdf
#     tempfile = Tempfile.new(["credit_report_#{Time.now.to_i}", '.pdf'])
#     open(tempfile, "wb") do |file|
#       file.write(decode_and_return_embedded_file)
#     end
#     filename
#   end

# end

require 'rails_helper'

RSpec.describe Credco::ResponseParser, type: :model do
  let!(:dummy_credco_response) { Credco::Client::DUMMY_RESPONSE }

  describe '#credit_report_identifier' do
    it 'returns credit report identifier' do
      expect(described_class.new(credco_response: dummy_credco_response).credit_report_identifier).to eq '112159128410000'
    end
  end

  describe "embedded_file?" do
    it "returns true when there is an embedded pdf file" do
      expect(described_class.new(credco_response: dummy_credco_response)).to have_embedded_file
    end

    it "returns false when there is not" do
      expect(described_class.new(credco_response: '')).to_not have_embedded_file
    end
  end

  describe "generate_credit_report_pdf" do
    subject { described_class.new(credco_response: dummy_credco_response) }
    it "returns a file object which can be attached to a lease application attachment" do
      expect(subject.generate_credit_report_pdf).to be_kind_of(Tempfile)
    end
  end

  describe "credit_scores" do
    context "with a normal credit report containing scores" do
      subject { described_class.new(credco_response: dummy_credco_response) }
      it "returns an array of credit scores" do
        expect(subject.credit_scores).to eq([756, 732])
      end
    end
    context "containing fraud alerts and having no real scores" do
      # DUMMY_PATH = Rails.root.join('lib', 'data', 'credco_success.xml').to_s.freeze
      # DUMMY_RESPONSE = File.read(DUMMY_PATH).freeze
      let!(:credco_response) { File.read(Rails.root.join('spec', 'data', 'credco_responses', 'no_credit_report_fraud_alert.xml')) }
      subject { described_class.new(credco_response: credco_response) }
      it "returns an empty array because there are no credit scores" do
        expect(subject.credit_scores).to eq([])
      end
    end
  end
end

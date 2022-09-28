require 'rails_helper'

RSpec.describe PdftkClient, type: :model do
  describe '#extract_last' do
    it 'creates new file with last x pages of document extracted', :retry => 3, :retry_wait => 10 do
      client = PdftkClient.new(source_file: "#{Rails.root}/spec/data/merge-report.pdf")
      result_path = client.extract_last(pages: 3)
      length = PdftkClient.new(source_file: result_path).doc_length

      expect(result_path).to include "#{Rails.root}/tmp/"
      expect(result_path).to include ".pdf"
      expect(length).to eq 3
    end
  end

  describe '#extract_risk_based_pricing_letter' do
    it 'extracts pages -2 and -3 from merge report', :retry => 3, :retry_wait => 10 do
      client = PdftkClient.new(source_file: "#{Rails.root}/spec/data/merge-report.pdf")
      result_path = client.extract_risk_based_pricing_letter
      length = PdftkClient.new(source_file: result_path).doc_length

      expect(result_path).to include "#{Rails.root}/tmp/"
      expect(result_path).to include ".pdf"
      expect(length).to eq 2
    end
  end

  describe '#doc_length' do
    it 'returns length of document' do
      client = PdftkClient.new(source_file: "#{Rails.root}/spec/data/merge-report.pdf")
      expect(client.doc_length).to eq 14
    end
  end
end

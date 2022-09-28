require 'rails_helper'
require 'zip'
=begin
RSpec.describe ExportAccessDbJob, type: :job do
  let!(:setting) { create :application_setting }
  describe 'CSV Generation' do
    let!(:lessee) { create(:lessee, :submittable, :with_valid_phone_numbers) }
    let!(:colessee) { create(:lessee, :submittable, :with_valid_phone_numbers) }

    it 'correctly generates CSV file 1' do
      app           = create(:lease_application, lessee: lessee, colessee: colessee, application_identifier: '2002040001')
      filepath      = ExportAccessDbJob.new.generate_csv_one
      result_values = CSV.table(filepath).by_row.values_at(0)[0]

      aggregate_failures do
        expect(result_values[:applicant_number].to_s).to be_blank
        expect(result_values[:primary_applicant]).to eq app.lessee&.decorate&.display_name
        expect(result_values[:primary_ssn]).to eq without_alphanumeric(app.lessee.ssn).to_i
        expect(result_values[:co_applicant]).to eq app&.colessee&.decorate&.display_name
        expect(result_values[:co_ssn]).to eq without_alphanumeric(app&.colessee&.ssn).to_i
        expect(result_values[:number_and_street]).to eq app.lessee&.home_address&.street1
        expect(result_values[:unit]).to eq app.lessee&.home_address&.street2.to_i
        expect(result_values[:city]).to eq app.lessee&.home_address&.city
        expect(result_values[:state]).to eq app.lessee&.home_address&.state
        expect(result_values[:zip].to_s).to eq app.lessee&.home_address&.zipcode
        expect(result_values[:county]).to eq app.lessee&.home_address&.county
        expect(result_values[:primary_phone]).to eq app.lessee&.mobile_phone_number.to_i
        expect(result_values[:secondary_phone].to_s).to eq app.lessee&.home_phone_number
        expect(result_values[:email_address]).to eq app.lessee&.email_address
        expect(result_values[:credit_score]).to eq app.lessee&.highest_fico_score
        expect(result_values[:co_credit_score]).to eq app&.colessee&.highest_fico_score
        expect(result_values[:credit_tier]).to eq app&.lease_calculator&.credit_tier_number.to_i
      end
    end

    it 'correctly generates CSV file 2' do
      app           = create(:lease_application, lessee: lessee, colessee: colessee, application_identifier: '2002040002')
      filepath      = ExportAccessDbJob.new.generate_csv_two
      result_values = CSV.table(filepath).by_row.values_at(0)[0]

      aggregate_failures do
        expect(result_values[:applicant_number].to_s).to eq app.application_identifier
        expect(result_values[:primary_applicant]).to eq app.lessee&.decorate&.display_name
        expect(result_values[:application_received_date]).to eq to_excel_serial_number(app.created_at)
        expect(result_values[:dealer]).to eq app.dealer&.dealership&.name&.upcase
        expect(result_values[:dealer_contact]).to eq app.dealer&.full_name&.upcase
        expect(result_values[:requested_vehicle]).to eq app&.lease_calculator.decorate.vehicle_display_name
        expect(result_values[:credit_decision_date]).to eq to_excel_serial_number(app.credit_decision_date)
        expect(result_values[:credit_decision]).to eq app&.credit_status&.humanize
        expect(result_values[:credit_decision_notes]).to eq ''
        expect(result_values[:lease_package_sent]).to eq to_excel_serial_number(app&.documents_issued_date)
        expect(result_values[:funding_amount]).to eq app&.lease_calculator&.remit_to_dealer&.to_f
      end
    end
  end

  describe '#perform' do
    it 'correctly zips files' do
      create(:lease_application)
      zip_filepath = ExportAccessDbJob.new.perform(email: 'testemail@example.com')
      Zip::File.open(zip_filepath) do |zip_file|
        expect(zip_file.size).to eq(3)
      end
    end

    it 'emails CSV to given address' do
      create(:lease_application)
      mailer = double(deliver_now: true)
      expect(DealerMailer).to receive(:access_db_export).with(hash_including(:filepath, :recipient => 'testemail@example.com')).and_return(mailer)
      ExportAccessDbJob.new.perform(email: 'testemail@example.com')
    end
  end

  def without_alphanumeric(string)
    string.gsub(/[-,.\/\\()]/, '').gsub(' ', '')
  end

  def to_excel_serial_number(date)
    return '' if date.blank?
    excel_count_starts_on = Date.new(1899, 12, 30)
    (date.to_date - excel_count_starts_on).to_i
  end
end
=end
require 'rails_helper'

RSpec.describe LeasePackageDocument, type: :model do
  include ActionView::Helpers::NumberHelper
  let!(:lessee) { create(:lessee, :with_addresses) }
  let!(:colessee) { create(:lessee, :with_addresses) }

  let!(:other_lessee) { create(:lessee, :with_addresses) }
  let!(:other_colessee) { create(:lessee, :with_addresses) }
  
  let!(:dealership_lease_package_template) { create(:dealership_lease_package_template) }
  let!(:customer_lease_package_template) { create(:customer_lease_package_template) }
  let!(:deal) { create(:lease_application, :approved_with_contingencies, :all_texas, :with_four_references, lessee: lessee, colessee: colessee) }
  let!(:lease_document_request) { create(:lease_document_request, lease_application: deal, equipped_with: "equipped", service_contract_term: 5) }
  let(:deal_not_in_tx) { create(:lease_application, :approved_with_contingencies, :with_four_references, lessee: other_lessee, colessee: other_colessee) }
  let(:lease_package_document) { described_class.new(deal) }
  let(:lease_package_output) { lease_package_document.generate.file.path }
  let!(:lease_package_fields) { lease_package_document.form_fields }
  let(:pdf_forms) { PdfForms.new(PdftkConfig.executable_path) }
  let(:generated_lease_package_fields) do
    pdf_forms.get_fields(lease_package_output).inject({}) do |r, v|
      r.merge({ v.name => v.value })
    end
  end

  before do
    allow_any_instance_of(described_class).to receive(:should_flatten?).and_return(false)
    allow_any_instance_of(PDFUploader).to receive(:path).and_return(File.join(Rails.root, 'spec', 'data', 'lease_package.pdf'))
  end

  def selected_field_totals(labels)
    lease_package_fields.select { |k,v| v if labels.include?(k) }.values.map(&:to_f).sum
  end

  def format(totals)
    sprintf("%0.2f", totals)
  end

  def date_format(date)
    date.strftime("%m/%d/%Y")
  end

  it "replaces whitespace in filenames with underscores" do
    deal.lessee.first_name = "Name Space"
    expect(lease_package_document.output_path.to_s).not_to include(" ")
    expect(lease_package_document.output_path.to_s).to include("_")
  end

  it 'should populate the full name on the customer' do
    expect(lease_package_fields['Lessee1 Name Copy']).to eq(deal.lessee.full_name_with_middle_initial)
  end

  it 'should populate the Vin field with the Lease Docs Request vin number' do
    expect(lease_package_fields['B-VIN']).to eq(deal.last_lease_document_request.asset_vin)
  end

  it 'should display Joint Application if their is a cosigner on the deal' do
    expect(lease_package_fields["Individual/Joint/Cosigner"]).to eq("Joint")
  end

  it 'should populate the Service checkbox on the deal if the lease_docs_request has wheel and tire, service, or pre paid maintenance' do
    expect(lease_package_fields['Service Contract Box']).to eq("Yes")
  end

  it 'should populate the term on the deal with the lowest term period on the lease_docs_request' do
    expect(lease_package_fields['Service Term']).to eq("5")
  end

  it 'should populate the applicant\'s home_phone or mobile phone on the deal' do
    expect(lease_package_fields["Applicant Home/Cell Number"]).to eq(lessee.home_phone)
  end

  it "should populate the gap_term field" do
    expect(lease_package_fields["GapTerm"]).to eq(lease_document_request.gap_contract_term.to_s)
  end

  it "should populate the gap_term checkbox if the gap_term is greater than 0" do
    expect(lease_package_fields["Gap Insurance Box"]).to eq("Yes")
  end

  it "should populate the Delivery Date" do
    expect(lease_package_fields["TodaysDate"]).to eq(date_format lease_document_request.delivery_date)
  end

end

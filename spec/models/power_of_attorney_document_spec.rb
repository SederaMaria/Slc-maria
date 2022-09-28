require 'rails_helper'

RSpec.describe PowerOfAttorneyDocument do
  context "with a lease app that has a lessee and a lease doc request" do
    let!(:address) { create(:address, state: 'FL') } #not illinois, IL is special - see below!
    let!(:lessee) { create(:lessee, home_address: address) }
    let!(:lease_application) { create(:lease_application, :can_request_lease_documents, lessee: lessee) }
    let!(:ldr) { create(:lease_document_request, lease_application: lease_application) }
    let!(:lessee_power_of_attorney_document) { PowerOfAttorneyDocument.new(lease_application, lessee) }

    context "with a lessee" do
      let(:lessee_power_of_attorney_fields)   { lessee_power_of_attorney_document.form_fields }

      it { expect(lessee_power_of_attorney_fields["Year"]).to eq(ldr.asset_year) }
      it { expect(lessee_power_of_attorney_fields["Make"]).to eq(ldr.asset_make) }
      it { expect(lessee_power_of_attorney_fields["Model"]).to eq(ldr.asset_model) }
      it { expect(lessee_power_of_attorney_fields["VIN"]).to eq(ldr.asset_vin) }
      it { expect(lessee_power_of_attorney_fields["CurrentDate"]).to eq(Date.today.strftime("%m/%d/%Y")) }
      it { expect(lessee_power_of_attorney_fields["LeaseNumber"]).to eq(lease_application.application_identifier) }
      it { expect(lessee_power_of_attorney_fields["LesseeFullName"]).to eq(lessee.full_name_with_middle_initial) }
      it { expect(lessee_power_of_attorney_fields["LesseeState"]).to eq(lessee.home_address.try(:state)) }
    end

    describe "generate" do
      it "generates and returns a file successfully" do
        expect(lessee_power_of_attorney_document.generate).to be_kind_of(File)
      end
    end
  end

  context "when the lessee resides in Illinois" do
    let!(:address) { create(:address, state: 'IL') }
    let!(:il_lessee) { create(:lessee, home_address: address) }
    let!(:lease_application) { create(:lease_application, :can_request_lease_documents, lessee: il_lessee) }
    let!(:ldr) { create(:lease_document_request, lease_application: lease_application) }
    let!(:lessee_power_of_attorney_document) { PowerOfAttorneyDocument.new(lease_application, il_lessee) }

    context "with a lessee" do
      let(:lessee_power_of_attorney_fields)   { lessee_power_of_attorney_document.form_fields }

      it "blah" do
        expect(lessee_power_of_attorney_fields["Year"]).to eq(ldr.asset_year)
      end
      it { expect(lessee_power_of_attorney_fields["Make"]).to eq(ldr.asset_make) }
      it { expect(lessee_power_of_attorney_fields["Model"]).to eq(ldr.asset_model) }
      it { expect(lessee_power_of_attorney_fields["VIN"]).to eq(ldr.asset_vin) }
      it { expect(lessee_power_of_attorney_fields["CurrentDate"]).to eq(Date.today.strftime("%m/%d/%Y")) }
      it { expect(lessee_power_of_attorney_fields["LeaseNumber"]).to eq(lease_application.application_identifier) }
      it { expect(lessee_power_of_attorney_fields["LesseeFullName"]).to eq(il_lessee.full_name_with_middle_initial) }
      it { expect(lessee_power_of_attorney_fields["LesseeState"]).to eq(il_lessee.home_address.try(:state)) }
    end

    describe "generate" do
      it "generates and returns a file successfully" do
        expect(lessee_power_of_attorney_document.generate).to be_kind_of(File)
      end
    end
  end
end
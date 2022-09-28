require 'rails_helper'

=begin
RSpec.describe ValidateVinJob, type: :job do

  let!(:lease_document_request) { create(:lease_document_request) }
  let!(:vin_validation) { create(:vin_validation, validatable: lease_document_request) }
  
  context "with a valid lease doc request" do
    before do
      allow_any_instance_of(VinVerificationNpa).to receive(:vin_matches_make_model_and_year?).and_return(true)
      allow_any_instance_of(VinVerificationNpa).to receive(:formatted_xml_response).and_return('Hello Im stubbed')
    end
    it "should mark the validation as valid" do
      expect {
        described_class.perform_now(vin_validation.id)
      }.to change { 
        vin_validation.reload.status
      }.from('status_unvalidated').to('status_valid')
    end 
    it "should store the vin verification result xml" do
      expect {
        described_class.perform_now(vin_validation.id)
      }.to change { 
        vin_validation.reload.validation_response
      }.from(nil).to('Hello Im stubbed')
    end
  end

  context "with an invalid lease doc request" do
    before do
      allow_any_instance_of(VinVerificationNpa).to receive(:vin_matches_make_model_and_year?).and_return(false)
      allow_any_instance_of(VinVerification).to receive(:formatted_xml_response).and_return('Hello Im a failed response')
    end
   
    it "should mark the validation as invalid" do
      expect {
        described_class.perform_now(vin_validation.id)
      }.to change { 
        vin_validation.reload.status
      }.from('status_unvalidated').to('status_invalid')
    end 

    it "should store the vin verification result xml" do
      expect {
        described_class.perform_now(vin_validation.id)
      }.to change { 
        vin_validation.reload.validation_response
      }.from(nil).to('Hello Im a failed response')
    end
  end
end
=end
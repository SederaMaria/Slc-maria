require 'rails_helper'
=begin
RSpec.describe Api::V1::LeaseApplicationsController, type: :controller do
  

  describe 'POST /create_funding_delay' do
    before do
      request.headers['Authorization'] = "Bearer #{user.auth_token}"
      post :create_funding_delay, params: { application_identifier: lease_application.application_identifier, funding_delays_attributes: { status: "Required", notes: "Notes" } }
    end

    context 'valid params' do
      let(:lessee) { create(:lessee) }
      let!(:lease_application) { create(:lease_application, lessee: lessee, application_identifier: "2002030006") }
      let(:user) { create(:admin_user, auth_token: SecureRandom.hex(13), auth_token_created_at: Time.now) }


      it 'should validate message' do
        expect(json_parse(response.body)["message"]).to eq("Lease Application Funding Delay sucessfully created")
      end

      it "returns http success" do
        expect(response).to have_http_status(:success)
      end
    end

    context 'invalid params' do
      let!(:lease_application) { OpenStruct.new({application_identifier: "100"}) }
      let(:user) { create(:admin_user, auth_token: SecureRandom.hex(13), auth_token_created_at: Time.now) }
      
      it "returns http success" do
        expect(response).to have_http_status(:not_found)
      end

      it 'response should have same input fee' do
        expect(json_parse(response.body)["errors"]["LeaseApplication"]).to eq('does not exist.')
      end

      it 'should have content_type' do
        expect(response.content_type).to eq("application/json")
      end
    end
    
  end

  private

  def json_parse(body)
    JSON.parse(body)
  end

end
=end
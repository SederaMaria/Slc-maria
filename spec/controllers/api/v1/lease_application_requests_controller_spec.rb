require 'rails_helper'

RSpec.describe Api::V1::LeaseApplicationRequestsController, type: :controller do
  
  describe 'GET /new_prenote' do
    before do
      request.headers['Authorization'] = "Bearer #{user.auth_token}"
      get :new_prenote, params: { application_identifier: lease_application.application_identifier }
    end

=begin
    context 'valid params' do
      let(:lessee) { create(:lessee) }
      let!(:lease_application) { create(:lease_application, lessee: lessee, application_identifier: "2002030006") }
      let(:user) { create(:admin_user, auth_token: SecureRandom.hex(13), auth_token_created_at: Time.now) }

      it 'should schedule sidekiq job' do
        expect(PrenoteJob.jobs.size).to eq(1)
      end

      it 'should validate message' do
        expect(json_parse(response.body)["message"]).to eq("Prenote is being requested.")
      end

      it "returns http success" do
        expect(response).to have_http_status(:success)
      end
    end
=end
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

    context 'invalid auth_token' do
      let(:lessee) { create(:lessee) }
      let!(:lease_application) { create(:lease_application, lessee: lessee, application_identifier: "100") }
      let(:user) { create(:admin_user, auth_token: SecureRandom.hex(13)) }
      
      it "returns http success" do
        expect(response).to have_http_status(:unauthorized)
      end

      it 'response should have errors key' do
        expect(json_parse(response.body)).to have_key("errors")
      end

      it 'should have content_type' do
        expect(response.content_type).to eq("application/json")
      end
    end
  end


  private

  def json_parse body
    JSON.parse(body)
  end
end

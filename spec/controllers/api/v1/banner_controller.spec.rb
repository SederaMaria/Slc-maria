require 'rails_helper'

RSpec.describe Api::V1::BannerController, type: :controller do

  describe 'GET /index' do
    before do
      request.headers['Authorization'] = "Bearer #{user.auth_token}"
      get :index
    end

    context 'valid auth_token' do
      let(:user) { create(:admin_user, auth_token: SecureRandom.hex(13), auth_token_created_at: Time.now) }
      let(:json_keys) { %w{id headline message active createdAt updatedAt createdByAdminId updatedByAdminId} }
      
      context 'Request with valid params' do
        it "returns http success" do
          expect(response).to have_http_status(:success)
        end

        it 'should have content_type' do
          expect(response.content_type).to eq("application/json")
        end

        it "Should have banners key" do
          expect(json_parse(response.body)).to have_key('banners')
        end

        it "Should have valid keys" do
          json_obj = JSON.parse response.body          
          banner_obj = json_obj['banners'] # Returns an array

          expect(banner_obj[0].keys).to contain_exactly(*json_keys)
        end

      end
    end    
  end

  private

  def json_parse body
    JSON.parse(body)
  end

end

require 'rails_helper'

RSpec.describe Api::V1::LeaseApplicationGpsUnitsController, type: :controller do
  before(:all) do
    @unit1 = create(:lease_application_gps_unit)
  end

  lease_application_gps_unit = LeaseApplicationGpsUnit.find_by_id(3)
  
  describe 'GET /index' do

    before do
      request.headers['Authorization'] = "Bearer #{user.auth_token}"
      get :index
    end

    context 'valid auth_token' do
      let(:user) { create(:admin_user, auth_token: SecureRandom.hex(13), auth_token_created_at: Time.now) }
      
      context 'Request with valid params' do
        it "returns http success" do
          expect(response).to have_http_status(:success)
        end

        it 'should have content_type' do
          expect(response.content_type).to eq("application/json")
        end

        it "is valid with valid attributes" do
          expect(@unit1).to be_valid
        end
      end
    end    
  end

end

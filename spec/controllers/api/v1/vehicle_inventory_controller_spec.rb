require 'rails_helper'

RSpec.describe Api::V1::VehicleInventoryController, type: :controller do
  describe 'GET index' do
    context 'with token' do
      it 'returns ok status' do
        user = create(:admin_user, auth_token: SecureRandom.hex(13), auth_token_created_at: Time.now)        
        request.headers['Authorization'] = "Bearer #{user.auth_token}"

        get :index
        expect(response).to have_http_status(:ok)
      end
    end

    context 'without token' do
      it 'returns unauthorized status' do
        get :index
        expect(response).to have_http_status(:unauthorized)
      end
    end
  end

  describe 'POST create' do
    context 'without token' do
      it 'returns unauthorized status' do
        post :create
        expect(response).to have_http_status(:unauthorized)
      end
    end
  end

  describe 'PUT/PATCH update' do
    context 'without token' do
      it 'returns unauthorized status' do
        put :update, params: { id: 1 }
        expect(response).to have_http_status(:unauthorized)
      end
    end
  end
end

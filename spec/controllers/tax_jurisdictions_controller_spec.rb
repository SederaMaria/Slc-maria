require 'rails_helper'

RSpec.describe TaxJurisdictionsController, type: :controller do

  describe "GET #index" do
    context "while logged in as a dealer" do
      login_dealer
      it "returns http success" do
        get :index, format: :json, params: { us_state: :florida }
        expect(response).to have_http_status(:success)
      end

      context "with a missing state return an empty json array" do
        it "returns http success" do
          get :index, format: :json, params: { us_state: '' }
          expect(response).to have_http_status(:success)
          expect(response.body).to eq(Array.new.to_json)
        end
      end
    end

    context "while logged in as an admin" do
      login_admin_user
      it "returns http success" do
        get :index, format: :json, params: { us_state: :florida }
        expect(response).to have_http_status(:success)
      end
    end

    it "returns not found when not logged in" do
      get :index, format: :html, params: { us_state: :florida }
      expect(response).to have_http_status(:not_found)
    end
  end
end

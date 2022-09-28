require 'rails_helper'

RSpec.describe Api::V1::AdjustedCapitalizedCostRangesController, type: :controller do
  make = Make.find_by_id(1)

  describe "GET /index" do

    before do
      request.headers['Authorization'] = "Bearer #{user.auth_token}"
      get :index, params: { make_id: make.id }
    end

    context 'valid auth_token' do
      let(:user) { create(:admin_user, auth_token: SecureRandom.hex(13), auth_token_created_at: Time.now) }
      
      context 'Request with valid params' do
        it "returns http success" do
          expect(response).to have_http_status(:success)
        end

        #it 'response should have count 5' do
        #  expect(json_parse(response.body)["data"].count).to eq(5)
        #end

        it 'should have content_type' do
          expect(response.content_type).to eq("application/json")
        end
      end
    end

    context 'invalid auth_token' do
      let(:user) { create(:admin_user, auth_token: SecureRandom.hex(13)) }
      context 'Request with valid params' do
        it "returns http unauthorized" do
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
  end

  describe 'PATCH /update' do
    before do
      request.headers['Authorization'] = "Bearer #{user.auth_token}"
      patch :update, params: { id: adjusted_capitalized_cost_range.id, acquisition_fee_cents: 10000 }
    end

    context 'Updating acquisition_fee_cents' do
      let(:adjusted_capitalized_cost_range) { AdjustedCapitalizedCostRange.first }
      let(:user) { create(:admin_user, auth_token: SecureRandom.hex(13), auth_token_created_at: Time.now) }

      it "returns http success" do
        expect(response).to have_http_status(:success)
      end

      it 'response should have same input fee' do
        expect(AdjustedCapitalizedCostRange.first.acquisition_fee_cents).to eq(10000)
      end

      it 'should have content_type' do
        expect(response.content_type).to eq("application/json")
      end
    end

    context 'Updating acquisition_fee_cents' do
      let(:adjusted_capitalized_cost_range) { OpenStruct.new({id: 100}) }
      let(:user) { create(:admin_user, auth_token: SecureRandom.hex(13), auth_token_created_at: Time.now) }

      it "returns http success" do
        expect(response).to have_http_status(:not_found)
      end

      it 'response should have same input fee' do
        expect(json_parse(response.body)["message"]).to eq('Range not found.')
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

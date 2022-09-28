require 'rails_helper'
=begin
RSpec.describe Api::V1::CreditTiersController, type: :controller do
    let!(:make)         { create(:make, lms_manf: 'HARLEY-DAV') }
    #let!(:model_group)  { 
    #  create(:model_group, name: 'Touring', make_id: 1, minimum_dealer_participation_cents: 2000, residual_reduction_percentage: 90.0)
    #}
    let!(:credit_tiers) {
        5.times.each do
            create(:credit_tier, make: make, effective_date: Date.today, end_date: Date.today + 1.year, model_group_id: 2 ) 
        end
    }

    describe "GET /index" do

        before do
            request.headers['Authorization'] = "Bearer #{user.auth_token}"
            get :index, { make_id: 1 }
        end

        context 'valid auth_token' do
            let(:user) { create(:admin_user, auth_token: SecureRandom.hex(13), auth_token_created_at: Time.now) }
        
            context 'Request with valid params' do
                it "returns http success" do
                    expect(response).to have_http_status(:success)
                end

                it 'response should have count 5 credit tier ids' do
                    expect(json_parse(response.body)["credit_tiers"].count).to eq(5)
                end

                it 'response should have count 5 data' do
                    expect(json_parse(response.body)["data"].count).to eq(5)
                end

                it 'should have content_type' do
                    expect(response.content_type).to eq("application/json")
                end
            end
        end

        context 'invalid auth_token' do
            let(:user) { create(:admin_user, auth_token: SecureRandom.hex(13)) }
            context 'Request with valid params' do
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
    end

    describe 'PUT /update' do
        before do
            request.headers['Authorization'] = "Bearer #{user.auth_token}"
            put :update, params: { id: CreditTier.first.id, payment_limit_percentage: 10.1 }
        end

        context 'Updating payment_limit_percentage' do
            let(:credit_tier) { CreditTier.first }
            let(:user) { create(:admin_user, auth_token: SecureRandom.hex(13), auth_token_created_at: Time.now) }

            it "returns http success" do
                expect(response).to have_http_status(:success)
            end

            it 'response should have same Payment Limit Percentage' do
                expect(credit_tier.payment_limit_percentage).to eq(10.1)
            end

            it 'should have content_type' do
                expect(response.content_type).to eq("application/json")
            end
        end
    end


    describe 'PUT /update fail' do
        
        before do
            request.headers['Authorization'] = "Bearer #{user.auth_token}"
            put :update, params: { id: CreditTier.first.id, payment_limit_percentage: 100 }
        end

        context 'Updating payment_limit_percentage' do
            let(:credit_tier) { CreditTier.first }
            let(:user) { create(:admin_user, auth_token: SecureRandom.hex(13), auth_token_created_at: Time.now) }

            it 'response should have error response' do
                expect(json_parse(response.body)["message"].count).to eq("Payment limit percentage Range should be between 0 to 99.")
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
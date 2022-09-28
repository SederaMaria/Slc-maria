require 'rails_helper'
=begin
RSpec.describe Api::V1::FundingDelayReasonsController, type: :controller do

    let!(:funding_delay_reasons) {
        5.times.each do
            create(:credit_tier, reason: "Reasons", active: true) 
        end
    }

    describe "GET /index" do

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

                it 'response should have count 5 credit tier ids' do
                    expect(json_parse(response.body)["funding_delay_reasons"].count).to eq(5)
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

  private

  def json_parse(body)
    JSON.parse(body)
  end

end
=end
require 'rails_helper'
=begin
RSpec.describe Api::V1::WelcomeCallTypesController, type: :controller do
    let!(:welcome_call_type)        { create(:welcome_call_type, active: true, description: "Welcome Call") }


    describe 'PUT /update_description' do
        before do
            request.headers['Authorization'] = "Bearer #{user.auth_token}"
            put :update_description, params: { id: welcome_call_type.id, description: "Updated"  }
        end

        context 'Updating payment_limit_percentage' do
            let(:welcome_call_type) { CreditTier.first }
            let(:user) { create(:admin_user, auth_token: SecureRandom.hex(13), auth_token_created_at: Time.now) }

            it "returns http success" do
                expect(response).to have_http_status(:success)
            end

            #it 'Should update description' do
            #    expect(welcome_call_type.description).to eq('Updated')
            #end

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
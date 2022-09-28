require 'rails_helper'
=begin
RSpec.describe Api::V1::LeaseApplicationReportsController, type: :controller do
  
  describe 'GET /export_csv' do
    before do
      request.headers['Authorization'] = "Bearer #{user.auth_token}"
      get :export_csv, params: { application_identifier: lease_application.application_identifier }
    end

    context 'valid params' do
      let(:lessee) { create(:lessee) }
      let!(:lease_application) { create(:lease_application, lessee: lessee, application_identifier: "2002030005") }
      let(:user) { create(:admin_user, auth_token: SecureRandom.hex(13), auth_token_created_at: Time.now) }

      it 'should schedule sidekiq job' do
        expect(ExportLeaseApplicationsJob.jobs.size).to eq(1)
      end

      it 'should validate message' do
        expect(json_parse(response.body)["message"]).to eq("Export Job has been scheduled successfully.")
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

    context 'invalid auth_token' do
      let(:lessee) { create(:lessee) }
      let!(:lease_application) { create(:lease_application, lessee: lessee, application_identifier: "2002030005") }
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

  describe 'GET /export_poa' do

    before do
      request.headers['Authorization'] = "Bearer #{user.auth_token}"
      get :export_csv, params: { application_identifier: lease_application.application_identifier, type: 'lessee' }
    end

    context 'valid params' do
      let(:lessee) { create(:lessee) }
      let!(:lease_application) { create(:lease_application, lessee: lessee, application_identifier: "2002030005") }
      let(:user) { create(:admin_user, auth_token: SecureRandom.hex(13), auth_token_created_at: Time.now) }

      it 'should validate message' do
        expect(json_parse(response.body)["message"]).to eq("Export Job has been scheduled successfully.")
      end

      it "returns http success" do
        expect(response).to have_http_status(:success)
      end

      it "sends an email" do
        filepaths = []; filepaths.push(Faker::File.file_name(dir: 'foo/bar', name: 'baz', ext: 'pdf'))
        
        expect { DealerMailer.lease_applications_export(recipient: user.email, filepaths: filepaths) }.to change { ActionMailer::Base.deliveries.count }.by(0)
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

    context 'invalid auth_token' do
      let(:lessee) { create(:lessee) }
      let!(:lease_application) { create(:lease_application, lessee: lessee, application_identifier: "2002030005") }
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

  describe 'POST /export_access_db' do
    before do
      request.headers['Authorization'] = "Bearer #{user.auth_token}"
      post :export_access_db
    end

    context 'valid params' do
      let(:lessee) { create(:lessee) }
      let!(:lease_application) { create(:lease_application, lessee: lessee, application_identifier: "2002030005") }
      let(:user) { create(:admin_user, auth_token: SecureRandom.hex(13), auth_token_created_at: Time.now) }

      it 'should schedule sidekiq job' do
        expect(ExportAccessDbJob.jobs.size).to eq(1)
      end

      it 'should validate message' do
        expect(json_parse(response.body)["message"]).to include("An Access DB Export will shortly be sent")
      end

      it "returns http success" do
        expect(response).to have_http_status(:success)
      end
    end

    context 'invalid auth_token' do
      
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


  describe 'POST /export_funding_delays' do
    before do
      request.headers['Authorization'] = "Bearer #{user.auth_token}"
      post :export_funding_delays
    end

    context 'valid params' do
      let(:lessee) { create(:lessee) }
      let!(:lease_application) { create(:lease_application, lessee: lessee, application_identifier: "2002030005", document_status: 'funding_delay') }
      let(:user) { create(:admin_user, auth_token: SecureRandom.hex(13), auth_token_created_at: Time.now) }

      it 'should schedule sidekiq job' do
        expect(ExportFundingDelayJob.jobs.size).to eq(1)
      end

      it 'should validate message' do
        expect(json_parse(response.body)["message"]).to include("A Funding Delay Export will shortly be sent to")
      end

      it "returns http success" do
        expect(response).to have_http_status(:success)
      end
    end

    context 'invalid auth_token' do
      
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
=end
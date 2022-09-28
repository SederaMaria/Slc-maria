require 'rails_helper'
=begin
RSpec.describe PrenoteJob, type: :job do

  describe 'queuing' do
    it 'only allows queing of one contest at a time' do
      expect {
        3.times { PrenoteJob.perform_async(1) }
      }.to change( PrenoteJob.jobs, :size).by(1)
    end
  end

  describe '#perform' do
    it 'request ACH API' do
      lessee = create(:lessee)
      lease_application = create(:lease_application, lessee: lessee)
      PrenoteJob.perform_async(lease_application.id)
      expect(ExportAccessDbJob.jobs.size).to eq(1)
      expect(lease_application.prenote_status).to eq "pending"
      expect(lease_application.prenote.last.usio_status).to eq "pending"
    end
  end
  
end
=end
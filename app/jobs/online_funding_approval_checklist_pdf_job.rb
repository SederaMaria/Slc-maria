class OnlineFundingApprovalChecklistPdfJob
  include Sidekiq::Worker
  sidekiq_options retry: 2

  def perform(lease_application_id)
    @app = LeaseApplication.find lease_application_id
    @online = @app.online_funding_approval_checklist
    generate_source
    @s3 = Aws::S3::Resource.new(region: 'us-east-1', credentials: Aws::Credentials.new(ENV['FUNDING_APPROVAL_CHECKLIST_ACCESS_KEY_ID'], ENV['FUNDING_APPROVAL_CHECKLIST_SECRET_ACCESS_KEY_ID']))
    @bucket = @s3.bucket(ENV['FUNDING_APPROVAL_CHECKLIST_BUCKET'])
    @source_foler = ENV['FUNDING_APPROVAL_CHECKLIST_FOLDER']
    upload(@source)
  end

  def generate_source
    @source ||= @online.prefilled
  end

  def upload(source)
    if @bucket.object("#{@source_foler}/#{File.basename(@source)}").upload_file(source)
      url = @bucket.object("#{@source_foler}/#{File.basename(@source)}").public_url
      File.delete(@source) if File.exist?(@source)
      @online.update(pdf_url: url)
    end
  end

end

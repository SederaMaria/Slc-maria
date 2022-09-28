require 'rails_helper'

RSpec.describe EmailNotificationResenderJob, type: :job do
  describe 'queuing' do
    it 'only allows queing of one at a time' do
      allow_any_instance_of(Notification).to receive(:send_notification).and_return(true) # stub this so it's not run on the callback from FactoryBot creation
      notification = create(:notification, :email, recipient: create(:dealer))
      expect {
        3.times { EmailNotificationResenderJob.perform_async(notification_id: notification.id) }
      }.to change(EmailNotificationResenderJob.jobs, :size).by(1)
    end
  end

  describe '#perform' do
    it 're-sends email with original attachments' do
      application = create(:lease_application, credit_status: 'approved')
      dealer = create(:dealer)
      notification = create(:notification, :email, :with_attachments, notifiable: application, recipient: dealer)

      local_attachment_path = "#{Rails.root}/spec/data/merge-report.pdf"
      allow_any_instance_of(EmailNotificationResenderJob).to receive(:local_filepath).and_return(local_attachment_path)

      original_filename = notification.notification_attachments.first.upload.file.filename
      expect_any_instance_of(CreditDecisionNotificationMailer).to receive(:approved).with(application: application, dealer: dealer, files: { original_filename => local_attachment_path })

      EmailNotificationResenderJob.new.perform(notification_id: notification.id)
    end
  end
end

require 'rails_helper'

RSpec.describe EmailNotifier do
  describe '#resend' do
    it 're-sends the original send email message' do
      allow_any_instance_of(Notification).to receive(:send_notification).and_return(true)
      notification = create(:notification, :email, notification_content: 'credit_decision', notifiable: create(:lease_application))
      notifier = EmailNotifier.new(notification: notification)
      expect {
        notifier.resend
      }.to change(EmailNotificationResenderJob.jobs, :size).by(1)
    end
  end

  describe '#credit_decision' do
    it 'sends e-mail notification' do
      allow_any_instance_of(Notification).to receive(:send_notification).and_return(true)
      notification = create(:notification, :email, notification_content: 'credit_decision', notifiable: create(:lease_application))
      expect { 
        EmailNotifier.new(notification: notification).credit_decision
      }.to change(CreditDecisionNotificationJob.jobs, :size).by(1)
    end
  end

  describe '#lease_documents_requested' do
    it 'sends e-mail notification' do
      app = create(:lease_application)
      notification = create(:notification, :email, :lease_document_request, notifiable: app)
      ldr = LeaseDocumentRequest.find(notification.data['lease_document_request_id'])
      mailer = double(deliver_later: true)

      expect(DealerMailer).to receive(:documents_requested).with(application_id: app.id, lease_request_id: ldr.id).and_return(mailer)

      EmailNotifier.new(notification: notification).lease_documents_requested
    end
  end
end

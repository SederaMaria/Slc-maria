require "rails_helper"

RSpec.describe DealershipMailer, type: :mailer do
  describe '#notify_underwriting' do
    it 'should render correctly' do
      application = create(:lease_application, credit_status: 'approved', application_identifier: '1001001')
      workflow = WorkflowStatus.underwriting_review
      application.update(workflow_status: workflow)
      application.notify_underwriting

      mail = described_class.notify_underwriting(recipient: 'test@speedleasing.com', app: application)

      expect(mail.subject).to include(application.application_identifier)
      expect(mail.subject).to include("Lease Application #{application.application_identifier} needs your review")
      expect(mail.body.encoded).to include(application.id.to_s)
      expect(mail.body.encoded).to include("view this application")
    end

  end

end

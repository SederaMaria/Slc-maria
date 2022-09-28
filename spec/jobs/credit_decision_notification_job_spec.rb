require 'rails_helper'

RSpec.describe CreditDecisionNotificationJob, type: :job do
  describe 'queuing' do
    it 'only allows queing of one per recipient' do
      allow_any_instance_of(Notification).to receive(:send_notification).and_return(true) # stub this so it's not run on the callback from FactoryBot creation
      notification = create(:notification, :email, recipient: create(:dealer))
      expect {
        3.times { CreditDecisionNotificationJob.perform_async(notification_id: notification.id) }
      }.to change(CreditDecisionNotificationJob.jobs, :size).by(1)
    end
  end

  describe '#perform' do
    it 'sends credit decision notification mail to each dealer' do
      dealer       = create(:dealer)
      application  = create(:lease_application, dealership: dealer.dealership, credit_status: 'approved')
      notification = create(:notification, :email, recipient: dealer, notifiable: application)
      mailer       = double(deliver_now: true)
      expect(CreditDecisionNotificationMailer).to receive(:approved).and_return(mailer)

      subject.perform(notification_id: notification.id)
    end

    it 'stores attachment under notification_attachments model' do
      lessee = create(:lessee)
      lessee.credit_reports << create(:credit_report, status: 'success')
      create(:lease_application_attachment, lessee: lessee)
      dealer       = create(:dealer)
      application  = create(:lease_application, lessee: lessee, credit_status: 'approved', dealership: dealer.dealership)
      notification = create(:notification, :email, recipient: dealer, notifiable: application)

      create(:lease_application_attachment, lessee: lessee)
      credit_report_path = "#{Rails.root}/spec/data/merge-report.pdf"

      allow_any_instance_of(CreditDecisionNotificationJob).to receive(:local_credit_report_path).and_return(credit_report_path)
      mailer = double(deliver_now: true)
      allow(CreditDecisionNotificationMailer).to receive(:approved).and_return(mailer)

      subject.perform(notification_id: notification.id)

      expect(notification.notification_attachments.size).to eq 2
    end

    context 'approved' do
      it 'attaches risk based pricing letter' do
        lessee = create(:lessee)
        lessee.credit_reports << create(:credit_report, status: 'success')
        create(:lease_application_attachment, lessee: lessee)
        dealer             = create(:dealer)
        application        = create(:lease_application, lessee: lessee, credit_status: 'approved', dealership: dealer.dealership)
        notification       = create(:notification, :email, recipient: dealer, notifiable: application)
        credit_report_path = "#{Rails.root}/spec/data/merge-report.pdf"
        allow_any_instance_of(CreditDecisionNotificationJob).to receive(:local_credit_report_path).and_return(credit_report_path)

        mailer = double(deliver_now: true)
        expected_filename = "Risk Based Pricing - #{application&.application_identifier} - #{lessee&.first_name&.upcase} #{lessee&.last_name&.upcase}.pdf"
        expect(CreditDecisionNotificationMailer).to receive(:approved).with(application: application, dealer: dealer, files: hash_including(expected_filename)).and_return(mailer)

        subject.perform(notification_id: notification.id)
      end

      it 'attaches prefilled letter' do
        dealer             = create(:dealer)
        lessee             = create(:lessee)
        application        = create(:lease_application, lessee: lessee, credit_status: 'approved', dealership: dealer.dealership, application_identifier: '1923081')
        notification       = create(:notification, :email, notifiable: application, recipient: dealer)
        credit_report_path = "#{Rails.root}/spec/data/merge-report.pdf"

        allow_any_instance_of(CreditDecisionNotificationJob).to receive(:local_credit_report_path).and_return(credit_report_path)

        mailer            = double(deliver_now: true)
        expected_filename = "Approved for #{application.application_identifier} #{lessee.name.upcase} and #{application.colessee.name.upcase}.pdf"
        expect(CreditDecisionNotificationMailer).to receive(:approved).with(application: application, dealer: dealer, files: hash_including(expected_filename)).and_return(mailer)

        subject.perform(notification_id: notification.id)
      end
    end

    context 'declined' do
      it 'attaches prefilled letter' do
        dealer       = create(:dealer)
        lessee       = create(:lessee)
        application  = create(:lease_application, lessee: lessee, credit_status: 'declined', dealership: dealer.dealership, application_identifier: '1923081')
        notification = create(:notification, :email, recipient: dealer, notifiable: application)
        allow_any_instance_of(CreditDecisionNotificationJob).to receive(:local_credit_report_path).and_return("#{Rails.root}/spec/data/merge-report.pdf")

        mailer            = double(deliver_now: true)
        expected_filename = "Declined for #{application.application_identifier} #{lessee.name.upcase} and #{application.colessee.name.upcase}.pdf"
        expect(CreditDecisionNotificationMailer).to receive(:declined).with(application: application, dealer: dealer, files: hash_including(expected_filename)).and_return(mailer)
        subject.perform(notification_id: notification.id)
      end
    end
  end
end

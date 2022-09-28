require "rails_helper"

RSpec.describe CreditDecisionNotificationMailer, type: :mailer do
  describe '#approved' do
    it 'should render correctly' do
      application = create(:lease_application, credit_status: 'approved', application_identifier: '1001001')
      dealer = create(:dealer)

      mail = described_class.approved(application: application, dealer: dealer)

      expect(mail.subject).to include(application.application_identifier)
      expect(mail.body.encoded).to include('Thank you')
    end

    it 'should add attachments' do
      application = create(:lease_application, credit_status: 'approved', application_identifier: '1001001')
      dealer = create(:dealer)
      mail = described_class.approved(application: application, dealer: dealer, files: { 'merge_report.pdf' => "#{Rails.root}/spec/data/merge-report.pdf" })
      expect(mail.attachments[0].filename).to eq 'merge_report.pdf'
    end
  end

  describe '#approved_with_contingencies' do
    it 'should render correctly' do
      application = create(:lease_application, credit_status: 'approved_with_contingencies', application_identifier: '1001001')
      dealer = create(:dealer)

      mail = described_class.approved_with_contingencies(application: application, dealer: dealer)

      expect(mail.subject).to include(application.application_identifier)
      expect(mail.body.encoded).to include('Thank you')
    end

    it 'should add attachments' do
      application = create(:lease_application, credit_status: 'approved_with_contingencies', application_identifier: '1001001')
      dealer = create(:dealer)
      mail = described_class.approved_with_contingencies(application: application, dealer: dealer, files: { 'merge_report.pdf' => "#{Rails.root}/spec/data/merge-report.pdf" })
      expect(mail.attachments[0].filename).to eq 'merge_report.pdf'
    end
  end

  describe '#requires_additional_information' do
    it 'should render correctly' do
      application = create(:lease_application, credit_status: 'requires_additional_information', application_identifier: '1001001')
      dealer = create(:dealer)

      mail = described_class.requires_additional_information(application: application, dealer: dealer)

      expect(mail.subject).to include(application.application_identifier)
      expect(mail.body.encoded).to include('Thank you')
    end
  end

  describe '#declined' do
    it 'should render correctly' do
      application = create(:lease_application, credit_status: 'declined', application_identifier: '1001001')
      dealer = create(:dealer)

      mail = described_class.declined(application: application, dealer: dealer)

      expect(mail.subject).to include(application.application_identifier)
      expect(mail.body.encoded).to include('Thank you')
    end

    it 'should add attachments' do
      application = create(:lease_application, credit_status: 'declined', application_identifier: '1001001')
      dealer = create(:dealer)
      mail = described_class.declined(application: application, dealer: dealer, files: { 'merge_report.pdf' => "#{Rails.root}/spec/data/merge-report.pdf" })
      expect(mail.attachments[0].filename).to eq 'merge_report.pdf'
    end
  end

  describe '#rescinded' do
    it 'should render correctly' do
      application = create(:lease_application, credit_status: 'rescinded', application_identifier: '1001001')
      dealer = create(:dealer)

      mail = described_class.rescinded(application: application, dealer: dealer)

      expect(mail.subject).to include(application.application_identifier)
      expect(mail.body.encoded).to include('Thank you')
    end
  end

  describe '#withdrawn' do
    it 'should render correctly' do
      application = create(:lease_application, credit_status: 'withdrawn', application_identifier: '1001001')
      dealer = create(:dealer)

      mail = described_class.withdrawn(application: application, dealer: dealer)

      expect(mail.subject).to include(application.application_identifier)
      expect(mail.body.encoded).to include('Thank you')
    end
  end
end

require 'rails_helper'

RSpec.describe DealerMailer, type: :mailer do
  let!(:lessee) { create(:lessee, :with_valid_phone_numbers, :with_addresses) }
  let!(:colessee) { create(:lessee, :with_valid_phone_numbers, :with_addresses) }
  let!(:dealership) { create(:dealership, name: 'D\'Amore, Wintheiser and Conn') }
  let!(:dealer) { create(:dealer,dealership: dealership) }
  let!(:dealer2) { create(:dealer,dealership: dealership) }
  let!(:application) { create(:lease_application, :can_request_lease_documents, lessee: lessee, colessee: colessee,dealership: dealership, dealer: dealer) }
  let!(:lease_document_request) { create(:lease_document_request, lease_application: application) }
  let!(:vin_validation) { create(:vin_validation, validatable: lease_document_request) }
  
  describe "#documents_requested" do
    
    let!(:mail) { described_class.documents_requested(application_id: application.id,lease_request_id: lease_document_request.id) }
    let!(:admin) { create(:admin_user) }

    it 'renders the template', :retry => 3 do
      aggregate_failures do
        expect(mail.subject).to eql("Lease Document Request for #{application.application_identifier}")
        expect(mail.body.encoded).to include("Lease Document Requested")
        expect(mail.body.encoded).to include(ERB::Util.html_escape(lessee.name.upcase))
        expect(mail.body.encoded).to include(ERB::Util.html_escape(colessee.name.upcase))
        expect(mail.body.encoded).to include(ERB::Util.html_escape(dealer.first_name.upcase))
        expect(mail.body.encoded).to include(lease_document_request.asset_make)
        expect(mail.body.encoded).to include(lease_document_request.asset_vin)
        expect(mail.body.encoded).to include(lease_document_request.asset_color)
        expect(mail.body.encoded).to include(lease_document_request.gap_contract_term.to_s)
        expect(mail.body.encoded).to include(ERB::Util.html_escape(dealership.name))
        expect(mail.body.encoded).to include(vin_validation.status)
        expect(mail.body.encoded).to include("Emails: #{dealership.dealers.pluck(:email).join(', ')}")
        expect(mail.body.encoded).to include("Dealership Address: #{dealership.address&.full_name}")
        expect(mail.body.encoded).to include("Exact Odometer Mileage: #{lease_document_request.exact_odometer_mileage}")
      end
    end
  end

  describe "#dealer_removed_colessee" do
    
    let!(:mail) { described_class.dealer_removed_colessee(application: application, colessee: colessee) }
    let!(:admin) { create(:admin_user) }

    it 'renders the template', :retry => 3 do
      aggregate_failures do
        expect(mail.subject).to eql("Colessee Removed from #{application.application_identifier}")
        expect(mail.body.encoded).to include("Colessee Removed from")
        expect(mail.body.encoded).to include(ERB::Util.html_escape(lessee.name.upcase))
        expect(mail.body.encoded).to include(ERB::Util.html_escape(colessee.name.upcase))
        expect(mail.body.encoded).to include(ERB::Util.html_escape(dealer.first_name.upcase))
      end
    end
  end

  describe "#dealer_added_colessee" do
    let!(:mail) { described_class.dealer_added_colessee(application: application) }
    let!(:admin) { create(:admin_user) }

    it 'renders the template', :retry => 3 do
      aggregate_failures do
        expect(mail.subject).to eql("Colessee added to #{application.application_identifier}")
        expect(mail.body.encoded).to include("Colessee added to")
        expect(mail.body.encoded).to include(ERB::Util.html_escape(lessee.name.upcase))
        expect(mail.body.encoded).to include(ERB::Util.html_escape(colessee.name.upcase))
        expect(mail.body.encoded).to include(ERB::Util.html_escape(dealer.first_name.upcase))
      end
    end
  end

  describe "#application_submitted" do
    let(:application_submission_mail) { described_class.application_submitted(application_id: application.id) }
    it 'should include the subject', :retry => 3 do
      expect(application_submission_mail.subject).to eql("New Application from #{dealership.name}")
    end
  end

  describe "#file_attachment_notification" do
    let(:attachment) { create(:lease_application_attachment, lease_application: application)}
    let(:application_submission_mail) { described_class.file_attachment_notification(attachment_id: attachment.id) }
    it 'should include the subject', :retry => 3 do
      expect(application_submission_mail.subject).to eql("Stipulation Attachment added to #{application.application_identifier}")
    end
  end

  describe "#bike_change_submitted" do
    context "with a lessee and colessee" do
      let(:bike_change_mail) { described_class.bike_change_submitted(application.id,"Harley Davidson","10000.00") }
      it 'should include the subject', :retry => 3 do
        expect(bike_change_mail.subject).to include("Bike Change Submitted for")
        expect(bike_change_mail.body.encoded).to include(ERB::Util.html_escape lessee.name)
        expect(bike_change_mail.body.encoded).to include(ERB::Util.html_escape "Coapplicant Name: #{colessee.name}")
        expect(bike_change_mail.body.encoded).to include("Harley Davidson")
        expect(bike_change_mail.body.encoded).to include("10000.00")      
      end

      let(:application_submission_mail) { described_class.application_submitted(application_id: application.id) }
      it 'should include the subject', :retry => 3 do
        expect(application_submission_mail.subject).to eql("New Application from #{dealership.name}")
      end
    end

    context "with a lessee only" do
      let!(:lessee_application) { create(:lease_application, :can_request_lease_documents, lessee: lessee, colessee: nil, dealership: dealership, dealer: dealer) }
      let(:bike_change_mail) { described_class.bike_change_submitted(lessee_application.id,"Harley Davidson","10000.00") }
      it 'should include the subject', :retry => 3 do
        expect(bike_change_mail.subject).to include("Bike Change Submitted for")
        expect(bike_change_mail.body.encoded).to include(ERB::Util.html_escape lessee.name)
        expect(bike_change_mail.body.encoded).to include(ERB::Util.html_escape 'Coapplicant Name: N/A')
        expect(bike_change_mail.body.encoded).to include("Harley Davidson")
        expect(bike_change_mail.body.encoded).to include("10000.00")      
      end

      let(:application_submission_mail) { described_class.application_submitted(application_id: application.id) }
      it 'should include the subject', :retry => 3 do
        expect(application_submission_mail.subject).to eql("New Application from #{dealership.name}")
      end
    end
  end

  describe '#attachment_distribution' do
    it 'should include the subject' do
      upload = double(url: 'example.com/doc.pdf')
      application = create(:lease_application, application_identifier: '1001aas1')
      attachment = create(:lease_application_attachment, lease_application: application)
      dealer = create(:dealer)

      allow(attachment).to receive(:upload).and_return(upload)

      mail = DealerMailer.attachment_distribution(attachment: attachment, dealer: dealer)

      expect(mail.subject).to include(application.application_identifier)
    end

    it 'should include a link to attachment' do
      upload = double(url: 'example.com/doc.pdf')
      application = create(:lease_application)
      attachment = create(:lease_application_attachment, lease_application: application)
      dealer = create(:dealer)

      allow(attachment).to receive(:upload).and_return(upload)

      mail = DealerMailer.attachment_distribution(attachment: attachment, dealer: dealer)

      expect(mail.body.encoded).to include(upload.url)
    end
  end

  describe '#reference_added' do
    it 'should include the subject' do
      application = create(:lease_application, application_identifier: '1001001')
      reference = create(:reference)

      mail = DealerMailer.reference_added(application: application, reference: reference)
      expect(mail.subject).to include(application.application_identifier)
    end

    it 'body should render correctly', :retry => 3 do
      application = create(:lease_application, application_identifier: '1001001')
      reference = create(:reference)

      mail = DealerMailer.reference_added(application: application, reference: reference)
      expect(mail.body.encoded).to include(reference.full_name)
    end
  end

  describe '#welcome_email' do
    it 'should include the subject' do
      dealer = create(:dealer)
      mail = DealerMailer.welcome_email(recipient: dealer, reset_password_token: 'resettoken')
      expect(mail.subject).to include('Action Required')
    end

    it 'body should render correctly' do
      dealer = create(:dealer)
      reset_token = 'resettoken'
      mail = DealerMailer.welcome_email(recipient: dealer, reset_password_token: reset_token)
      expect(mail.body.encoded).to include(dealer.email)
      expect(mail.body.encoded).to include(reset_token)
    end
  end
end

require 'rails_helper'

RSpec.describe MailToDealershipJob, type: :job do
  describe '#perform' do
    it 'sends attachment distribution mail to each dealer' do
      dealership = create(:dealership)
      dealers = create_list(:dealer, 3)
      dealership.dealers << dealers
      application = create(:lease_application, dealership: dealership)
      attachment = create(:lease_application_attachment, lease_application: application)

      mailer = double(deliver_now: true)
      expect(DealerMailer).to receive(:attachment_distribution).with(attachment: attachment, dealer: dealers[0]).and_return(mailer)
      expect(DealerMailer).to receive(:attachment_distribution).with(attachment: attachment, dealer: dealers[1]).and_return(mailer)
      expect(DealerMailer).to receive(:attachment_distribution).with(attachment: attachment, dealer: dealers[2]).and_return(mailer)

      MailToDealershipJob.perform_now(attachment.id)
    end
  end
end

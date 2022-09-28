require 'rails_helper'

RSpec.describe Admins::LeaseApplicationAttachments::DealershipMailsController, type: :controller do
  describe '#create' do
    context 'as admin' do
      login_admin_user
      it 'mails to dealership' do
        attachment = create(:lease_application_attachment)
        expect(MailToDealershipJob).to receive(:perform_later).with(attachment.id)
        request.env["HTTP_REFERER"] = 'example.com'
        post :create, params: { id: attachment.id }
      end
    end

    context 'as dealer' do
      login_dealer
      it 'doesnt allow action' do
        attachment = create(:lease_application_attachment)
        expect(MailToDealershipJob).not_to receive(:perform_later)
        post :create, params: { id: attachment.id }
      end
    end
  end
end

require 'rails_helper'

RSpec.describe SendWelcomeEmail do
  describe '#call' do
    it 'resets recipients reset password token' do
      recipient = create(:dealer)
      expect {
        SendWelcomeEmail.call(recipient: recipient)
      }.to change { recipient.reload.reset_password_token }
    end

    it 'sends email' do
      recipient = create(:dealer)
      expect_any_instance_of(DealerMailer).to receive(:welcome_email).with(hash_including(:reset_password_token, :recipient))
      SendWelcomeEmail.call(recipient: recipient)
    end
  end
end

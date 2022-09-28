require 'rails_helper'

RSpec.describe InAppNotifier do
  describe '#application_submitted' do
    it 'sends in-app notification on recipient main channel' do
      notification = create(:notification, :in_app)
      dealer_id = notification.recipient.id
      expect(NotificationsChannel).to receive(:broadcast_to).with("dealer:#{dealer_id}", hash_including(:template))
      allow(NotificationsChannel).to receive(:broadcast_to)
      InAppNotifier.new(notification: notification).application_submitted
    end

    it 'sends in-app notification on notifiable scoped channel' do
      notification = create(:notification, :in_app)
      dealer_id = notification.recipient.id
      channel = "dealer:#{dealer_id}:lease_application:#{notification.notifiable.id}"
      expect(NotificationsChannel).to receive(:broadcast_to).with(channel, hash_including(:template))
      allow(NotificationsChannel).to receive(:broadcast_to)
      InAppNotifier.new(notification: notification).application_submitted
    end
  end
end

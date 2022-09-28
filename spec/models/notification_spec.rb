# == Schema Information
#
# Table name: notifications
#
#  id                   :bigint(8)        not null, primary key
#  read_at              :datetime
#  recipient_id         :integer          not null
#  recipient_type       :string           not null
#  notification_mode    :string           not null
#  notification_content :string           not null
#  data                 :jsonb
#  created_at           :datetime         not null
#  updated_at           :datetime         not null
#  url                  :string
#  notifiable_id        :integer
#  notifiable_type      :string
#
# Indexes
#
#  index_notifications_on_notifiable_id_and_notifiable_type  (notifiable_id,notifiable_type)
#  notifications_recipient_and_mode_idx                      (recipient_id,recipient_type,notification_mode)
#  notifications_recipient_idx                               (recipient_id,recipient_type)
#

require 'rails_helper'

RSpec.describe Notification, type: :model do
  describe 'validations' do
    it 'asks specified mode to validate data' do
      app = create(:lease_application)
      notification = Notification.new(
        recipient: create(:dealer),
        notification_mode: 'InApp',
        notification_content: 'application_submitted',
        notifiable: app
      )

      expect_any_instance_of(InAppNotifier).to receive(:validate).and_return(true)
      expect_any_instance_of(Notification).to receive(:send_notification).and_return(true)

      notification.save
    end
  end

  describe 'after_create' do
    it 'sends notification' do
      app = create(:lease_application)
      notification = Notification.new(
        recipient: create(:dealer),
        notification_mode: 'InApp',
        notification_content: 'application_submitted',
        notifiable: app
      )

      expect_any_instance_of(InAppNotifier).to receive(:application_submitted)

      notification.save
    end
  end

  describe '#create_for_admins' do
    it 'creates a notification for all admin users' do
      app = create(:lease_application)
      admins = create_list(:admin_user, 5)
      dealer = create(:dealer)
      dealership = create(:dealership)
      dealership.dealers << dealer

      Notification.create_for_admins(
        notification_mode: 'InApp',
        notification_content: 'application_submitted',
        notifiable: app
      )

      admins.each do |admin|
        expect(admin.notifications.count).to eq 1
      end

      expect(dealer.notifications.count).to eq 0
    end
  end

  describe '#create_for_dealership' do
    it 'creates a notification for all dealership dealers' do
      app = create(:lease_application)
      admin = create(:admin_user)
      dealership = create(:dealership)
      dealers = create_list(:dealer, 5)
      dealership.dealers << dealers

      Notification.create_for_dealership({
        notification_mode: 'InApp',
        notification_content: 'application_submitted',
        notifiable: app
      }, dealership: dealership
                                        )

      dealers.each do |dealer|
        expect(dealer.notifications.count).to eq 1
      end

      expect(admin.notifications.count).to eq 0
    end

    it 'creates a notification for all representatives' do
      app = create(:lease_application)
      admin = create(:admin_user)
      dealership = create(:dealership)
      representatives = create_list(:dealer_representative, 5)
      dealership.dealer_representatives << representatives

      Notification.create_for_dealership({
                                           notification_mode: 'InApp',
                                           notification_content: 'application_submitted',
                                           notifiable: app
                                         }, dealership: dealership
      )

      representatives.each do |rep|
        expect(rep.notifications.count).to eq 1
      end

      expect(admin.notifications.count).to eq 0
    end
  end

  describe '#mark_as_read' do
    it 'updates read at column' do
      notification = create(:notification, :in_app)
      expect {
        notification.mark_as_read
      }.to change(notification, :read_at)
    end
  end
end

# == Schema Information
#
# Table name: notification_attachments
#
#  id              :bigint(8)        not null, primary key
#  notification_id :bigint(8)
#  description     :string
#  upload          :string
#  created_at      :datetime         not null
#  updated_at      :datetime         not null
#
# Indexes
#
#  index_notification_attachments_on_notification_id  (notification_id)
#

class NotificationAttachment < ApplicationRecord
  belongs_to :notification

  mount_uploader :upload, S3Uploader
end

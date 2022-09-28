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

class Notification < ApplicationRecord
  VALID_MODES = ['InApp', 'Email']
  ADMIN_URL  = 'https://admin.speedleasing.com/'
  DEALER_URL = 'https://dealer.speedleasing.com/'
  BASE_URL   = 'http://speedleasing.com/'

  belongs_to :recipient, polymorphic: true
  belongs_to :notifiable, polymorphic: true

  has_many :notification_attachments

  validates :notification_mode, presence: true, inclusion: VALID_MODES
  validate :validate_data

  after_create :set_url
  after_create :send_notification

  scope :unread, -> { where(read_at: nil) }
  scope :read, -> { where.not(read_at: nil) }
  scope :in_app, -> { where(notification_mode: 'InApp' ) }
  scope :email, -> { where(notification_mode: 'Email' ) }
  scope :credit_decision_emails, -> { where(notification_mode: 'Email', notification_content: 'credit_decision').order(created_at: :desc) }

  delegate :resend, to: :mode

  def self.create_for_support(attrs)
    Notification.create!(attrs.merge!(recipient: AdminUser.first_or_create!(
      first_name: 'SpeedLeasing',
      last_name:  'Support',
      password:   "#{SecureRandom.hex(12)}Sl%3",
      email:      ENV['SUPPORT_EMAIL']
    )))
  end

  def self.create_for_admins(attrs)
    AdminUser.all.each do |admin|
      Notification.create(attrs.merge!(recipient: admin))
    end
  end

  def self.create_for_dealership(attrs, dealership:)
    dealership.active_dealers.select{ |d| d.notify_credit_decision }.each do |dealer|
      Notification.create(attrs.merge!(recipient: dealer))
    end
    dealership.dealer_representatives.each do |rep|
      Notification.create(attrs.merge!(recipient: rep))
    end
  end

  def mark_as_read
    update_attribute(:read_at, Time.now)
  end

  def notification_text
    case self.notification_content
    when 'application_submitted'
      "#{self.notifiable.dealership.name} has submitted a new lease application."
    when 'bike_change'
      "#{self.notifiable.dealership.name} has requested a bike change"
    when 'colessee_added'
      "#{self.notifiable.dealership.name} has added a co-lessee to application #{self.notifiable&.decorate&.application_identifier}"
    when 'colessee_removed'
      "Colessee removed from Application #{self.notifiable&.decorate&.application_identifier}"
    when 'lease_attachment_added'
      "A new attachment has been added to Application #{self.notifiable&.decorate&.application_identifier}"
    when 'lease_documents_requested'
      "Lease Documents Requested for Application #{self.notifiable&.decorate&.application_identifier} by #{self.notifiable&.dealership&.name}"
    when 'reference_added'
      "A new reference has been added to Application #{self.notifiable&.decorate&.application_identifier}"
    else
      "Error: No template found."
    end          
  end

  def redirect_url
    if recipient_type == 'AdminUser'
      return url.gsub(BASE_URL, ADMIN_URL)
    else
      return url.gsub(BASE_URL, DEALER_URL)
    end
  end

  private
  def mode
    "#{notification_mode}Notifier".constantize.new(notification: self)
  end

  def validate_data
    mode.validate
  rescue NameError
    errors.add(:notification_mode, 'Invalid mode specified')
  end

  def send_notification
    mode.public_send(notification_content)
  end

  def set_url
    user_type = recipient_type == 'AdminUser' ? :admins : :dealers
    generated = Rails.application.routes.url_helpers.polymorphic_url([user_type, notifiable])
    self.update_attribute(:url, generated)
  end
end

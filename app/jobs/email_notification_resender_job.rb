class EmailNotificationResenderJob
  include Sidekiq::Worker

  sidekiq_options unique:      :until_executed,
                  unique_args: :unique_args

  def self.unique_args(args)
    notification = Notification.find(args[0]['notification_id'])
    [notification.notification_content, notification.recipient.email]
  end

  def perform(opts)
    opts.symbolize_keys!
    @notification = Notification.find(opts[:notification_id])
    @recipient    = notification.recipient
    @attachments  = {}

    fill_attachments
    send_mail
    touch_notification_timestamps
  end

  private
  attr_reader :recipient, :attachments, :notification

  def fill_attachments
    notification.notification_attachments.each do |attachment|
      attachments[filename(attachment)] = local_filepath(attachment.upload) unless attachments.keys.include?(filename(attachment))
    end
  end

  def filename(attachment)
    if attachment.description[-4..-1] == '.pdf'
      attachment.description
    else
      attachment.upload.file.filename
    end
  end

  def send_mail
    if notification.notification_content == 'credit_decision'
      CreditDecisionNotificationMailer.public_send(lease_application.credit_status.to_sym, application: lease_application, dealer: recipient, files: attachments).deliver_now
    else
      raise('EmailNotificationResenderJob does not yet support re-sending notifications with this content')
    end
  end

  def local_filepath(upload)
    destination_filepath = "#{Rails.root}/tmp/#{upload.file.filename}"
    remote_file          = open(upload.url)

    IO.copy_stream(remote_file, destination_filepath)
    return destination_filepath
  end

  def lease_application
    notification.notifiable
  end

  def touch_notification_timestamps
    notification.notification_attachments.update_all(updated_at: Time.now)
    notification.touch
  end
end

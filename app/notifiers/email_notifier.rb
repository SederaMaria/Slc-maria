class EmailNotifier
   
   STATUS = %w(funding_approved funded funding_delay)

  def initialize(notification:)
    @notification = notification
  end

  def validate
    responds_to_desired_message
    validates_lease_document_request if notification.notification_content == 'lease_documents_requested'
  end

  def resend
    content = notification.notification_content
    if STATUS.include? content
      public_send(content.to_sym)
    else
      EmailNotificationResenderJob.perform_in(30.seconds, notification_id: notification.id)
    end
  end

  def credit_decision
    CreditDecisionNotificationJob.perform_in(30.seconds, notification_id: notification.id, notification_content: notification.notification_content, recipient_email: notification.recipient.email)
  end

  def lease_documents_requested
    DealerMailer.documents_requested(application_id: notifiable.id, lease_request_id: notification.data['lease_document_request_id']).deliver_later(wait: 30.seconds)
  end
  
  def funding_delay
    DealerMailer.dealer_notification(application: notification.notifiable, dealer: notification.recipient, status: 'funding_delay').deliver_later(wait: 30.seconds)  
    if notification.notification_attachments.empty?
      notification.notification_attachments.create(
        description: "Funding Delay"
      )
    end
  end

  def funding_approved
    DealerMailer.dealer_notification(application: notification.notifiable, dealer: notification.recipient, status: 'funding_approved').deliver_later(wait: 30.seconds)  
    if notification.notification_attachments.empty?
      notification.notification_attachments.create(
        description: "Funding Approved"
      )
    end
  end

  def funded
    DealerMailer.dealer_notification(application: notification.notifiable, dealer: notification.recipient, status: 'funded').deliver_later(wait: 30.seconds)  
    if notification.notification_attachments.empty?
      notification.notification_attachments.create(
        description: "Funded"
      )
    end
  end
  
  private
  attr_reader :notification

  def notifiable
    notification.notifiable
  end

  def responds_to_desired_message
    unless self.respond_to? notification.notification_content
      notification.errors.add(:notification_content, "#{notification.notification_content} notification is not implemented")
    end
  end

  def validates_lease_document_request
    unless LeaseDocumentRequest.where(id: notification.data['lease_document_request_id']).present?
      notification.errors.add(:lease_document_request, "Invalid or no lease document request in notification data")
    end
  end
end

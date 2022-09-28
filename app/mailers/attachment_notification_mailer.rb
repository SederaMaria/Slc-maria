class AttachmentNotificationMailer < ApplicationMailer

    def notify(app:)
        @application_identifier = app.application_identifier
        send_to = []
        send_to.push(app&.lessee&.email_address) if ENV['NOTIFY_LESSEE_ATTACHMENT'] && app&.lessee&.email_address && ENV['MAILER_OUTGOING_LESSEE'].eql?('enabled')
        send_to.push(app&.dealership&.dealer_representatives&.map(&:email)) if ENV['NOTIFY_DEALERSHIP_ATTACHMENT']
        mail(from: "#{@application_identifier}#{ENV['ATTACHMENT_EMAIL_DOMAIN']}" ,to: send_to.flatten,  subject: "Supporting documentation")
    end

end

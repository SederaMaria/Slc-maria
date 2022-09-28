class IncomingEmailMailer < ApplicationMailer

    def lease_not_found(email_to:, subject:, message_id:, application_identifier:, reply_to:)
        @application_identifier = application_identifier
        mail(to: email_to,  subject: "Re: #{subject}", references: message_id, reply_to: reply_to)
    end

    def notify(app:, attachments:)
        @app = app
        @lessee = @app.lessee
        @attachments = attachments
        mail(
            to: ENV['SUPPORT_EMAIL'],  
            subject: "#{@lessee&.full_name} - #{@app.application_identifier} (#{@app&.dealership&.name})" 
            )
    end

    def threat_found_notification(sent_by:)
        @sent_by = sent_by
        mail(to: [ENV['EXCEPTION_RECIPIENTS'], ENV['SUPPORT_EMAIL']].flatten.compact,  subject: 'Threat Found')
    end 

end

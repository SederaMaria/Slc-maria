
class Api::V1::IncomingEmailsController < ApplicationController
    skip_before_action :verify_authenticity_token
    def validate
        begin
            if LeaseApplication.exists?(application_identifier: params[:application_identifier])
                render json: {message: "Successfully validated"}
            else
                # Tracing and studying `ATTACHMENT_EMAIL_DOMAIN`, emails might come from the following:
                # - lessee and dealer_representatives (from `AttachmentNotificationMailer`)
                # - admin_user from legacy admin portal (edit LeaseApplication)
                # - dealer from legacy dealer portal (show LeaseApplication)
                send_email = true
                unless ENV['MAILER_OUTGOING_LESSEE'].eql?('enabled')
                    send_email = !Lessee.exists?(email_address: params[:email_to])
                end

                IncomingEmailMailer.lease_not_found(
                    email_to: params[:email_to], 
                    subject: params[:subject], 
                    message_id: params[:message_id], 
                    application_identifier: params[:application_identifier],
                    reply_to: params[:reply_to]
                ).deliver_now! if send_email
                render json: {message: "Lease not found"}
            end
        rescue => exception
        render json: {message: "Error validating"}, status: 500 
        end
    end


    def add_attachments
        begin
            lease_application = LeaseApplication.find_by(application_identifier: params[:application_identifier])
            unless params[:upload].empty?
                attach_array = []
                params[:upload].each do |file|
                    attachment = lease_application.lease_application_attachments.new(upload: file, visible_to_dealers: false)
                    attachment.save
                    attach_array.push(attachment)
                end
                #notify
                IncomingEmailMailer.notify(app: lease_application, attachments: attach_array).deliver_now!
            end
            render json: {message: "Successfully added attachements"}
        rescue => exception
            Rails.logger.info(exception)
            render json: {message: "Error Adding Attachments"}, status: 500 
        end
    end

    def threat_found
        begin
            IncomingEmailMailer.threat_found_notification(sent_by: params[:sent_by]).deliver_now!
            render json: {message: "Successfully notified Support"}
        rescue => exception
            Rails.logger.info(exception)
            render json: {message: "Threat Notification Error"}, status: 500 
        end
    end
 
end
class DealershipMailer < ApplicationMailer
    include MailerHelper
    after_action :mail_logger
    default from: ENV['SUPPORT_EMAIL']
    
    def notify_approvers(recipient:, dealership:)
      @dealership = dealership
      mail(
        to: recipient,
        subject: "Dealership #{dealership.name} is ready for your approval")
    end

    def notify_underwriting(recipient:, app:)
      @app = app
      mail(
        to: recipient,
        subject: "Lease Application #{@app.application_identifier} needs your review")
    end

    def notify_dealership_expirations(recipients, cc_recipients, dealerships)
      @dealerships = dealerships
      mail(
        to: recipients,
        cc: cc_recipients,
        subject: "List of Dealership Licenses expiring in 30 days")
    end

    def notify_dealership_not_expires(recipients, cc_recipients)
      mail(
        to: recipients,
        cc: cc_recipients,
        subject: "List of Dealership Licenses expiring in 30 days")
    end
end

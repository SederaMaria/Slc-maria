class LesseeMailer < ApplicationMailer
  include MailerHelper
  include TemplateTagHelper
  after_action :mail_logger
  default from: ENV['FUNDING_EMAIL']
  
  def funding_package_received(recipient:, app:)
    @app = app
    @content_body = funding_package_received_template_email(app)
    mail(to: recipient,
         subject: "Welcome to Speed Leasing!")
  end


  def blackbox_auto_reject(recipient:, app:, datax_id:, response: )
    @app = app
    @datax = LeaseApplicationBlackboxRequest.find(datax_id)
    @content_body = blackbox_auto_reject_template_email(app, @datax)
    mail(
      from: ENV['SUPPORT_EMAIL'],
      to: recipient,
      subject: "Blackbox Sent REJECT for Lease Application - #{@app.application_identifier}")
  end


end
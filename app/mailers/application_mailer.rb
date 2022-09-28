class ApplicationMailer < ActionMailer::Base
  # Add other exceptions you want rescued in the array below
  ERRORS_TO_RESCUE = [
    Net::SMTPAuthenticationError
  ]
  rescue_from *ERRORS_TO_RESCUE do |exception|
    Rails.logger.info("Email not sent: invalid credentials")
  end
  
  default from: ENV['SUPPORT_EMAIL']
  layout 'mailer'
end

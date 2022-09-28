class SendAdminWelcomeEmail
  attr_reader :recipient, :mailer
  attr_accessor :token

  def initialize(recipient:)
    @recipient = recipient
    @token = ''
    @mailer = AdminMailer
  end

  def self.call(*args)
    new(*args).call
  end

  def call
    reset_recipient_password_token
    send_email
  end

private
  def reset_recipient_password_token
    @token = recipient.send(:set_reset_password_token)
  end

  def send_email
    mailer.welcome_email(recipient: recipient, reset_password_token: token).deliver_now
  end
end

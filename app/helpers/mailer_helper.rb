module MailerHelper
  
  def mail_logger
    full_message = @_message.dup
    full_message[:body] = nil
    CustomLogger.log_info("#{self.class.to_s}##{self.action_name}", full_message)
  end
  
end
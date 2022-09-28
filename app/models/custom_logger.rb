class CustomLogger
  
  def self.log_info(class_action_name,msg)
    Rails.logger.info(" [#{Time.now.utc.strftime('%B %-d %Y at %r %Z')}] - #{class_action_name}: #{msg}")
  end
  
  def self.log_debug(class_action_name,msg)
    Rails.logger.info(" [#{Time.now.utc.strftime('%B %-d %Y at %r %Z')}] - #{class_action_name}: #{msg}")
  end  
  
  def self.log_error(class_action_name,msg)
    Rails.logger.error(" [#{Time.now.utc.strftime('%B %-d %Y at %r %Z')}] - #{class_action_name}: #{msg}")
  end
  
end
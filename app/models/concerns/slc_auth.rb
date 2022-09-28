module SlcAuth

  extend ActiveSupport::Concern
  # Retrieves the policy for the user, given resource and action
  # Only checks security group policies for now
  # Throws an error if user (role) is not authorized for the action

  class SlcAuthException < StandardError
    attr_reader :user, :resource, :action, :reason

    def initialize(options = {})      
      @user  = options[:user]
      @resource = options[:resource]
      @action = options[:action]
      @reason = options[:reason]

      if reason 
        message = reason
      else
        message = "SlcAuth Policy Exception: #{user} not allowed to #{action} on #{resource}"
      end

      super(message)
    end
    
  end

  def authorize(user, resource, action)    
    user_id = user&.id
    user_name = user_id ? "#{user&.first_name} #{user&.last_name}" : nil

    resource_obj = Resource.find_by(name: resource)
    action_obj = Action.find_by(rights: action)
    
    resource_id = resource_obj&.id
    action_id = action_obj&.id
    
    if !user_id || !resource_id || !action_id
      reason = get_reason(user_id, resource, resource_id, action, action_id)

      raise SlcAuthException, user: user_name, resource: resource, action: action, reason: reason
    end

    user_security_roles = user&.security_roles

    if user_security_roles
      role_array = user_security_roles.map{|r| r['id']}
    end

    role_array.each do |role|
      allowed = Permission.find_by(security_role_id: role, resource_id: resource_id, action_id: action_id)

      if allowed
        return true
      end
    end

    raise SlcAuthException, user: user_name, resource: resource, action: action
  end

  private

  def get_reason(user_id, resource, resource_id, action, action_id)
    reason = "SlcAuth Error:"

    if !user_id
      reason += " user_id not found"
    end

    if !resource_id
      reason += " resource '#{resource}' not found in Resource model"
    end

    if !action_id
      reason += " action '#{action}' not found in Action model"
    end

    return reason
  end

end
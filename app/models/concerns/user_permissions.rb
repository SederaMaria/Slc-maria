module UserPermissions
  extend ActiveSupport::Concern

  def get_user_permissions(user)
    user_security_roles = user&.security_roles.pluck(:id)
    role_permissions = Permission.where(security_role_id: user_security_roles)

    role_resource_ids = role_permissions.distinct.pluck(:resource_id)
    role_resources = Resource.select(:id, :name).where(id: role_resource_ids)

    user_permission_arr = []

    role_resources.each do |data|
      action_ids = role_permissions.select(:action_id).where(resource_id: data.id)
      action_results = Action.select(:rights).where(id: action_ids)

      user_permission_arr << {
        resource: data['name'],
        actions: action_results.pluck(:rights)
      }
    end

    user_permission_arr
  end
end

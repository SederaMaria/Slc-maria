class Api::V1::SecurityRolesController < Api::V1::ApiController
  
  
  def can_see_welcome_call_dashboard
    roles = SecurityRole.where(can_see_welcome_call_dashboard: true).pluck(:description)
    render json: { security_roles: roles }
  end


  def security_roles_options
    options = SecurityRole.where(active: true).map{|x| {value: x.id, label: x.description}}
    render json: { security_roles_options: options } 
  end

end
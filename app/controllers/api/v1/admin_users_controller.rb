class Api::V1::AdminUsersController < Api::V1::ApiController
  include UnderscoreizeParams

  def need_change_password
    current_user.need_change_password?
    render json: { need_change_password: current_user.need_change_password? }
  end

  def expire_password
    admin = AdminUser.find(params[:id])

    begin
      admin.password_changed_at = nil
      admin.save
      render json: { message: 'Expired Admin User password' }
    rescue => exception
      render json: { message: admin.errors.full_messages }, status: 500
    end
  end

  def expire_session
    admin = AdminUser.find(params[:id])

    begin
      admin.auth_token = nil
      admin.save
      render json: { message: 'Deleted Admin User auth token' }
    rescue => exception
      render json: { message: admin.errors.full_messages }, status: 500
    end
  end

  def lock_user
    admin = AdminUser.find(params[:id])
    if admin.lock_access!(opts = { send_instructions: false })
      render json: {message: "Admin User successfully updated"}
    else
      render json: {message: "Problem updating Admin User"}, status: 500
    end
  end

  def unlock_user
    admin = AdminUser.find(params[:id])
    if admin.unlock_access!
      render json: {message: "Admin User successfully updated"}
    else
      render json: {message: "Problem updating Admin User"}, status: 500
    end
  end

  def index
    authorize(current_user, 'AdminUser', 'get')
    admins = AdminUser.all.order('id asc')
    admins = AdminUser.active.order('id asc') if params["active"]=="1"
    render json: ActiveModelSerializers::SerializableResource.new(admins, adapter: :json, key_transform: :camel_lower).as_json
  end

  def show
    authorize(current_user, 'AdminUser', 'get')
    admin = AdminUser.find(params[:id])
    render json: admin, each_serializer: AdminUserSerializer, adapter: :json, root: 'admin_user'
  end

  def update
    authorize(current_user, 'AdminUser', 'update')
    admin = AdminUser.find(params[:id])
    if admin.update(admin_user_params) && !admin_user_params.empty?
      save_dealerships(admin)
      save_security_roles(admin)
      render json: {message: "Admin User successfully updated"}
    else
      render json: {message: admin.errors.full_messages}, status: 500
    end
  end

  def get_pinned_tabs
    begin
      render json: { pinned_tabs: current_user.pinned_tabs }
    rescue => exception
      render json: {message: "Problem fetching pinned tabs"}, status: 500
    end
  end

  def update_pinned_tabs
    begin
      current_user.pinned_tabs = params[:pinned_tabs]
      current_user.save
      render json: { pinned_tabs: current_user.pinned_tabs }
    rescue => exception
      render json: {message: current_user.errors.full_messages}, status: 500
    end
  end

  def create
    authorize(current_user, 'AdminUser', 'create')
    admin = AdminUser.new(new_admin_user_params)
    admin.build_dealer_representative(
      email: admin.email,
      first_name: admin.first_name,
      last_name: admin.last_name,
      dealership_ids: dealerships_params["dealership_ids"],
      is_active: dealerships_params["is_dealer_representative"]
    )
    admin.security_role_ids = security_role_params['security_role_ids']

    if admin.save
      render json: { message: "Admin User successfully created" }
    else
      render json: { message: admin.errors.messages }, status: 500
    end
  end

  private 


  def admin_user_params
    params.permit(:first_name, :last_name, :email, :is_active, :job_title, :security_role_id)
  end

  def new_admin_user_params
    params.permit(:email, :password, :password_confirmation, :first_name, :last_name, :job_title, :is_active)
  end

  def dealerships_params
    params.permit(:is_dealer_representative, dealership_ids: [])
  end

  def security_role_params
    params.permit(security_role_ids: [])
  end

  
  def save_dealerships(admin)
    if admin.dealer_representative.nil?
      admin.create_dealer_representative(
        email: admin.email,
        first_name: admin.first_name,
        last_name: admin.last_name,
        dealership_ids: dealerships_params["dealership_ids"], 
        is_active: dealerships_params["is_dealer_representative"])
    else
      dealer_representative = admin.dealer_representative
      dealer_representative.dealership_ids = dealerships_params["dealership_ids"]
      dealer_representative.is_active = dealerships_params["is_dealer_representative"]
      dealer_representative.save
    end
  end

  def save_security_roles(admin)
    admin.security_role_ids = security_role_params['security_role_ids']
    admin.save    
  end

end

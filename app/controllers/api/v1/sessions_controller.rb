class Api::V1::SessionsController < Api::V1::ApiController
  skip_before_action :require_login!, only: [:create]

  include UserPermissions

  def create
    if params[:admin_login].present?

      resource = AdminUser.find_for_database_authentication(email: params[:admin_login][:email])
      resource ||= AdminUser.new
      if resource.valid_password?(params[:admin_login][:password])
        current_admin_user = resource
        auth_token = resource.generate_auth_token
        user_permissions = get_user_permissions(current_admin_user)
        render json: {
          status: true,
          message: 'Admin User Logged In Successfully',
          data: {
            id: resource.id,
            email: resource.email,
            first_name: resource.first_name,
            last_name: resource.last_name,
            auth_token: resource.auth_token,
            user_permissions: user_permissions
          }
        }
      else
        invalid_login_attempt
      end
    else
      resource = Dealer.find_for_database_authentication(email: params[:dealer_login][:email])
      resource ||= Dealer.new
      if resource.valid_password?(params[:dealer_login][:password])
        current_dealer = resource
        auth_token = resource.generate_auth_token
        render json: {
          status: true,
          message: 'Dealer Logged In Successfully',
          data: {
            full_name: resource.full_name,
            auth_token: resource.auth_token
          }
        }
      else
        invalid_login_attempt
      end
    end
  end

  def destroy
    resource = current_user
    resource.invalidate_auth_token
    render json: {
      status: true,
      message: 'User Logged Out Successfully'
    }
  end

  def logout_all_dealears
    Dealer.logged_in.each do |dealer|
      sign_out dealer
      dealer.invalidate_auth_token
    end
    sessions = ActiveRecord::SessionStore::Session.all
    sessions.each do |session|
      next if session.data['warden.user.dealer.key'].blank?

      session.destroy
    end
    render json: {
      status: true,
      message: 'All Dealers Logged Out Successfully'
    }
  end

  def validate_token
    # Utilize `require_login!`
    render json: nil, status: :ok
  end

  private

  def invalid_login_attempt
    render json: { errors: [{ detail: 'Error with your email or password' }] }, status: 401
  end
end

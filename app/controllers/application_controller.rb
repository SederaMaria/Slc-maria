class ApplicationController < ActionController::Base
  include SlcAuth
  protect_from_forgery with: :reset_session
  include SimpleAudit::Auditor  
  
  rescue_from SlcAuthException, with: :user_not_authorized

  # /auth/:token
  def auto_login    
    if (current_admin_user.present? && params[:path].include?('admins')) || (current_dealer.present? && params[:path].include?('dealers'))
      redirect_to params[:path].gsub(/(?<!^)\?/, '&').sub('&', '?') #regex if for params with filter ex: ?q[model_group_id_eq]=6&q[model_group_make_id_eq]=1&q[year_equals]=2018&commit=Filte   we relace & to ? we can filter.
      return
    elsif params[:token].present?      
      admin = AdminUser.find_by(auth_token: params[:token])
      if admin.present?        
        if admin.access_locked?
          admin_id = admin.id
          redirect_to new_admin_user_unlock_path
          return
        end
        sign_in admin, scope: :admins
      else
        dealer = Dealer.find_by(auth_token: params[:token])
        if dealer.blank?
          redirect_to "#{ENV['LOS_UI_URL']}/admins/login?p=0"
          return
        end
        sign_in dealer, scope: :dealers
      end
        redirect_to params[:path]
      return
    end
  end
  
  private
  
  def set_user_time_zone
    timezone = Time.find_zone(cookies[:timezone])
    Time.use_zone(timezone) { yield }
  end

  def user_not_authorized(exception)
    flash[:error] = "You are not authorized to perform this action."
    Rails.logger.info("Policy Exception")
    render json: { message: "Policy Exception: #{exception}" }, status: 401
  end    
  
end

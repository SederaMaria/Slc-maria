module ActiveAdmin
  class BaseController
    before_action :session_expires
		before_action :password_expires
		before_action :update_token_expiry
		before_action :redirect_rack_error_into_flash_error

    private
    def session_expires
      if active_admin_namespace.name == :dealers
        session[:expires_at] = current_dealer.current_sign_in_at + 24.hours
	      if session[:expires_at] < Time.current
	        reset_session
	        flash[:error] = 'Your session has expired. Please log in again.'
	        redirect_to new_dealer_session_path
	      end
	    else
	    	session[:expires_at] = current_admin_user.current_sign_in_at + 24.hours
	      if session[:expires_at] < Time.current
	        reset_session
	        flash[:error] = 'Your session has expired. Please log in again.'
					redirect_to  "#{ENV['LOS_UI_URL']}/admins/login?p=0"
      	end
    	end
		end
		
		def password_expires
			if active_admin_namespace.name == :dealers
				if current_dealer.need_change_password?
					store_location_for(:dealer, dealers_lease_applications_path)
					redirect_to dealer_password_expired_path
				end
			else
				if current_admin_user.need_change_password?
					store_location_for(:admin_user, admins_lease_applications_path)
					redirect_to admin_user_password_expired_path
				end
			end
		end

		def update_token_expiry
			if current_admin_user.present?
				current_admin_user.update(auth_token_created_at: 1.day.from_now, last_request_at: DateTime.now)
			end
		end

    # In coordination with `config/initializers/rack_attack.rb#throttled_responder`
    def redirect_rack_error_into_flash_error
      if params[:error].present? && params[:error] == "dup-req"
        tpath = params[:error_type].presence.try(:gsub, /[#\/]/, ".") || 'unknown'
        redirect_to request.path, flash: { error: (I18n.t("rack_attack.errors.#{tpath}", raise: true) rescue I18n.t('rack_attack.errors.default')) }
      end
    end
	end
end
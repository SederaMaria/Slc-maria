class Api::V1::ApiController < ApplicationController
  protect_from_forgery with: :null_session
  include Response
  include ExceptionHandler
  include ActiveAdmin::LeaseCalculatorHelper
  before_action :require_login!
  after_action :update_token_expiry!
  helper_method :user_signed_in?, :current_user

  def require_login!
    return true if authenticate_via_api_token
    if authenticate_token
      return false if check_last_request_at
      return true
    end

    # Dealer.logged_in.each do |dealer|
    #   sign_out dealer
    #   dealer.invalidate_auth_token
    # end
    # sessions = ActiveRecord::SessionStore::Session.all
    # sessions.each do |session|
    #   next if session.data['warden.user.dealer.key'].blank?
    #   session.destroy
    # end
    render json: { errors: [ { detail: "Access denied. Invalid or Expired Token." } ] }, status: 401
  end

  def current_user
    @_current_admin_user ||= authenticate_token
  end

  def user_signed_in?
   current_user.present?
  end

  private
  def authenticate_token    
    authenticate_with_http_token do |token, options|            
      admin = AdminUser.where(auth_token: token).where("auth_token_created_at >= ?", 1.day.ago).first
      if admin.nil?        
        Dealer.where(auth_token: token).where("auth_token_created_at >= ?", 1.day.ago).first
      else
        AdminUser.where(auth_token: token).where("auth_token_created_at >= ?", 1.day.ago).first
      end
    end
  end

  def update_token_expiry!
    if authenticate_token
      #current_user.update(auth_token_created_at: 1.day.from_now)
      current_user.update(auth_token_created_at: Time.zone.now)
    end
  end

  def check_last_request_at
    return false if authenticate_token.class.name.to_sym == :Dealer
    return false if authenticate_token&.last_request_at.nil? || authenticate_token.timedout?(authenticate_token&.last_request_at)
    true
  end

  def authenticate_via_api_token
    authenticate_with_http_token do |token, options|            
      ApiToken.where(access_token: token).first      
    end
  end

end


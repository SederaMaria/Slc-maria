class HomeController < ApplicationController
  before_action :clear_flash

  def index
    if(request.host.include?("dealers"))
      redirect_to "#{ENV['DEALER_PORTAL_BASE_URL']}"
    else
      redirect_to "#{ENV['ADMIN_PORTAL_BASE_URL']}/admins"
    end
  end

  private
  def clear_flash
    flash.discard
  end
end
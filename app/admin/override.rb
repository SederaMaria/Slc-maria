ActiveAdmin::Devise::SessionsController.class_eval do
  # prepend_before_action :check_captcha, only: [:create] # Change this to be any actions you want to protect.
  def after_sign_out_path_for(resource_or_scope)
    "#{ENV['LOS_UI_URL']}/admins/login?p=0"
  end

  private
    def check_captcha
      unless verify_recaptcha
        self.resource = resource_class.new sign_in_params
        respond_with_navigational(resource) { render :new }
      end 
    end
end
module ControllerMacros
  def login_admin_user
    before(:each) do
      @request.env["devise.mapping"] = Devise.mappings[:admin_user]
      @admin_user = FactoryBot.create(:admin_user)
      sign_in @admin_user # Using factory girl as an example
    end
  end

  def login_dealer
    before(:each) do
      @request.env["devise.mapping"] = Devise.mappings[:dealer]
      # user = FactoryBot.create(:user)
      # user.confirm! # or set a confirmed_at inside the factory. Only necessary if you are using the "confirmable" module
      @dealer = FactoryBot.create(:dealer)
      sign_in @dealer
    end
  end
end

RSpec.configure do |config|
  config.include Devise::Test::ControllerHelpers, type: :controller
  config.extend ControllerMacros, :type => :controller
end
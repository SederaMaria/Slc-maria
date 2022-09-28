RSpec.configure do |config|
  config.before(:each) do
    #Ensure ENV Vars for Credco are reset each spec
    ENV['CREDCO_SERVICE_URL'] = 'https://www.credcoconnect.com/cc/listener'
    ENV['CREDCO_LOGIN_ID'] = "4480464"
    ENV['CREDCO_PASSWORD'] = "4KBJFPHZ"
  end
end
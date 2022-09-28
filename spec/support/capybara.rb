Capybara.register_driver :chrome_headless do |app|
  capabilities = Selenium::WebDriver::Remote::Capabilities.chrome(
    chromeOptions: {
      args: %w[ no-sandbox headless disable-gpu ]
    }
  )
  Capybara::Selenium::Driver.new(app, browser: :chrome, desired_capabilities: capabilities)
end

Capybara.register_driver :chrome do |app|
  Capybara::Selenium::Driver.new(app,
    browser: :chrome,
    desired_capabilities: { "chromeOptions" => { "args" => %w{ window-size=1300,768 } } }
  )
end

#must allow this URL if Chromedriver needs to download a binary
WebMock.disable_net_connect!(allow: 'chromedriver.storage.googleapis.com', allow_localhost: true)

#Use a specific older Chrome driver, but only use it in the Solano CI environment

Capybara::Webkit.configure do |config|
  config.block_unknown_urls
end

if ENV.has_key?('TDDIUM')
  Chromedriver.set_version "2.24" #set a lower version in Solano environment only.
  Capybara.javascript_driver = :chrome
else #test environment
  #NOTE - IF YOU REALLY NEED TO SEE THE TESTS RUN, SWITCH TO `chrome` driver.
  Chromedriver.set_version "2.37"
  Capybara.javascript_driver = :chrome
  #Capybara.javascript_driver = :chrome_headless
end

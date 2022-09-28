# This file is copied to spec/ when you run 'rails generate rspec:install'
ENV["RAILS_ENV"] = 'test'
require File.expand_path('../../config/environment', __FILE__)
# Prevent database truncation if the environment is production
abort("The Rails environment is running in production mode!") if Rails.env.production?
require 'spec_helper'
require 'rspec/rails'
require 'devise'
require 'shoulda/matchers'
require 'support/sidekiq'

# Capybara integration
require 'capybara/rspec'
require 'capybara/rails'
require 'selenium-webdriver'
require 'site_prism'
require 'vcr'

include ActionDispatch::TestProcess
include Warden::Test::Helpers

Dir[Rails.root.join('spec/support/**/*.rb')].each { |f| require f }
ActiveJob::Base.queue_adapter = :test

# Add additional requires below this line. Rails is not loaded until this point!

# Requires supporting ruby files with custom matchers and macros, etc, in
# spec/support/ and its subdirectories. Files matching `spec/**/*_spec.rb` are
# run as spec files by default. This means that files in spec/support that end
# in _spec.rb will both be required and run as specs, causing the specs to be
# run twice. It is recommended that you do not name files matching this glob to
# end with _spec.rb. You can configure this pattern with the --pattern
# option on the command line or in ~/.rspec, .rspec or `.rspec-local`.
#
# The following line is provided for convenience purposes. It has the downside
# of increasing the boot-up time by auto-requiring all files in the support
# directory. Alternatively, in the individual `*_spec.rb` files, manually
# require only the support files necessary.
#
# Dir[Rails.root.join('spec/support/**/*.rb')].each { |f| require f }

# Checks for pending migration and applies them before tests are run.
# If you are not using ActiveRecord, you can remove this line.
ActiveRecord::Migration.maintain_test_schema!

RSpec.configure do |config|
  # Remove this line if you're not using ActiveRecord or ActiveRecord fixtures

  config.include FactoryBot::Syntax::Methods
  config.include FactoryBotMacros, type: :controller
  config.include AuditHelper
  # If you're not using ActiveRecord, or you'd prefer not to run each of your
  # examples within a transaction, remove the following line or assign false
  # instead of true.
  config.use_transactional_fixtures = true

  # RSpec Rails can automatically mix in different behaviours to your tests
  # based on their file location, for example enabling you to call `get` and
  # `post` in specs under `spec/controllers`.
  #
  # You can disable this behaviour by removing the line below, and instead
  # explicitly tag your specs with their type, e.g.:
  #
  #     RSpec.describe UsersController, :type => :controller do
  #       # ...
  #     end
  #
  # The different available types are documented in the features, such as in
  # https://relishapp.com/rspec/rspec-rails/docs
  config.infer_spec_type_from_file_location!

  # Filter lines from Rails gems in backtraces.
  config.filter_rails_from_backtrace!
  # arbitrary gems may also be filtered via:
  # config.filter_gems_from_backtrace("gem name")

  config.include Devise::Test::ControllerHelpers, type: :system
  config.include Devise::Test::IntegrationHelpers, type: :system
  #
  # Run  Bullet gem on specs
  # if Bullet.enable?
  #   config.before(:each) do
  #     Bullet.start_request
  #   end
  #
  #   config.after(:each) do
  #     Bullet.perform_out_of_channel_notifications if Bullet.notification?
  #     Bullet.end_request
  #   end
  # end
end

RSpec::Sidekiq.configure do |config|
  config.warn_when_jobs_not_processed_by_sidekiq = false
end

RSpec::Sidekiq.configure do |config|
  config.warn_when_jobs_not_processed_by_sidekiq = false
end

def sign_in_as_admin(admin:, password:)
  visit new_admin_user_session_path
  fill_in 'Email', with: admin.email
  fill_in 'Password', with: password
  click_button 'Login'
end

def sign_in_as_dealer(dealer)
  visit new_dealer_session_path
  fill_in 'dealer[email]', with: dealer.email
  fill_in 'dealer[password]', with: 'password'
  click_button 'Login'
end

def login_as_dealer_and_select_values
  login_as dealer, scope: :dealer
  calculator_page.load
  maximize_browser_window
  calculator_page.select_state and wait_for_ajax
  calculator_page.select_credit_tier and wait_for_ajax
  calculator_page.select_year and wait_for_ajax
  calculator_page.select_model and wait_for_ajax
  calculator_page.select_mileage_range and wait_for_ajax
  calculator_page.select_leasing_term('60') and wait_for_ajax
end


def login_as_dealer_and_select_values_and_fill_data
  login_as_dealer_and_select_values
  calculator_page.fill_dealer_sales_price and wait_for_ajax
  calculator_page.fill_documentation_fee and wait_for_ajax
  calculator_page.fill_prep_price and wait_for_ajax
end
# def wait_until
#   Timeout.timeout(10) do
#     sleep(0.1) until value = yield
#     value
#   end
# end

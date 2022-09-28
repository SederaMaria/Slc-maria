source 'https://rubygems.org'
ruby '2.7.2'

git_source(:github) do |repo_name|
  repo_name = "#{repo_name}/#{repo_name}" unless repo_name.include?("/")
  "https://github.com/#{repo_name}.git"
end

# Bundle edge Rails instead: gem 'rails', github: 'rails/rails'
# NOTE - we can return the the regular Rails gem after Rails 5.2 is released.
# The issue in my fork is fixed in Rails 5.2, but not reverted in Rails 5.1 unfortunately.
# gem 'rails', github: 'ZocaLoans/rails', branch: 'ldstudios/revert-db-structure-load-forced-errors' #'~> 5.1'
gem 'rails', '6.0.4.1'
gem 'dotenv-rails', groups: [:development, :test]

# gem 'webpacker'

# Use sqlitezz3 as the database for Active Record
gem 'pg'

# Use Puma as the app server
gem 'puma'
# Use SCSS for stylesheets
gem 'sass-rails', '~> 5.0'
# Use Uglifier as compressor for JavaScript assets
gem 'uglifier', '>= 1.3.0'
# Use CoffeeScript for .coffee assets and views
gem 'coffee-rails', '~> 4.2'
# See https://github.com/rails/execjs#readme for more supported runtimes
# gem 'therubyracer', platforms: :ruby

# Use jquery as the JavaScript library
gem 'underscore-rails'
# Turbolinks makes navigating your web application faster. Read more: https://github.com/turbolinks/turbolinks
gem 'turbolinks', '~> 5.2.0'
# Build JSON APIs with ease. Read more: https://github.com/rails/jbuilder
gem 'jbuilder', '~> 2.5'
gem 'thor' #suppress annoying warnings in the Console.  See: https://github.com/rails/rails/issues/27229
# Use ActiveModel has_secure_password
# gem 'bcrypt', '~> 3.1.7'
gem 'aasm'
# IMPORTANT NOTE:
# Whenever there are updates on master, run `bundle update singleton-rails`
# or `bundle update singleton-rails --conservative` (for Bundler 2+).
# It should update `revision` value from `Gemfile.lock`.
gem 'singleton-rails', github: 'speed-leasing/singleton-rails', branch: 'master'
gem 'foreman'
###

gem 'activeadmin'
gem 'activeadmin-select2', '0.1.8'
gem 'activeadmin_addons'
gem 'activeadmin_json_editor', '~> 0.0.7'
gem 'jquery-rails'
gem 'fancybox2-rails'

# Ransack: Sort/Filter
gem 'ransack'
gem 'select2-rails'
# Kaminari (pagination) stable release; don't upgrade
gem 'kaminari'

gem 'draper', '~> 3.0' #its not in the docs, but `decorates_with` only works with Draper
gem 'inherited_resources', '~> 1.7'
gem 'devise'
gem 'devise-security', github: 'devise-security/devise-security'
gem 'money', '~> 6.13.2'
gem 'money-rails', '~> 1.14.0'
gem 'slim-rails'
gem 'formtastic'
gem 'acts_as_list'
gem 'attr_encrypted' #Provides encryption for ActiveRecord fields - noteably Customer SSN
gem 'crypt_keeper'
gem 'carrierwave'
gem 'carrierwave-aws'
gem 'sidekiq'
gem 'sidekiq-unique-jobs'
gem 'redis', '~> 3.2' #Helps Redis load for ActionCable
gem 'redis-namespace'
gem 'bootstrap-sass'
gem 'smartystreets_ruby_sdk'
gem 'kickbox' # Email validation
gem 'twilio-ruby', '<= 4.5.0'
gem 'jasny-bootstrap-rails'
gem 'american_date'
gem 'savon' #SOAP API Wrapper
gem 'pdf-forms' # PDF generation (including interacting with templates)
gem 'nokogiri' #Canonical XML Parser for Ruby apps-
gem 'simple_stats' #Finally, simple mean, median, mode, sum, and frequencies for Ruby arrays and enumerables!
gem 'actionpack-page_caching'
gem 'exception_notification' #Exception emails
gem 'slack-notifier' #Add ability to send Exception Notifications to a Slack channel also.
gem 'gon', '~> 6.2' # Allow us to share Ruby objects directly for use in JavaScript
gem 'render_anywhere', :require => false
gem "ldstudios_ruby_calculator", github: 'ZocaLoans/ruby-calculator'
gem 'rubyzip'
gem 'rack-cors', require: 'rack/cors'
gem "roo", "~> 2.7.0"
gem "action_mailer_auto_url_options", github: 'speed-leasing/action_mailer_auto_url_options', branch: 'main' # Add the current request host and protocol in email URLs
gem 'rest-client'
gem 'js_cookie_rails', '~> 2.2'
gem 'activerecord-session_store'
gem 'pdf-reader'
gem 'finance_math'
# gem 'bigdecimal', '1.3.5'
# gem 'bigdecimal', '3.0.0'
gem 'bigdecimal', '1.4.4'

#https://github.com/Casecommons/pg_search
gem 'pg_search'
gem 'active_model_serializers'
gem 'rswag'
gem 'recaptcha'

# Rack middleware for blocking & throttling
gem 'rack-attack'

group :production, :test do
  gem 'rspec-rails'
end

group :development, :test do
  # Call 'byebug' anywhere in the code to stop execution and get a debugger console
  gem 'figaro'
  gem 'byebug', platform: :mri
  gem 'heroku_ops'
  gem 'heroku_rake_deploy', github: 'ZocaLoans/heroku_rake_deploy' #use version that doesn't run `rake db:seed` as part of the deploy process
  gem 'factory_bot_rails'
  gem 'annotate', github: 'ctran/annotate_models', branch: 'develop' #Suppress Ruby 2.4 deprecations until a new version comes out.
  gem 'awesome_print' # adds style to pry print out- we can remove this one if its too different for anyone
  gem 'pry-rails' # Debugging
  # gem 'pry-byebug' # adds step, next, finish, continue, and breakpoint commands to pry
  # gem 'pry-rescue' # run your server with rescue to open pry on any error 'bundle exec rescue rails s'
  # gem 'pry-stack_explorer' #adds up, down, frame, and show-stack to pry commands
  gem 'letter_opener'
  gem 'bullet'
  gem 'ffaker'
end

group :development do
  # Access an IRB console on exception pages or by using <%= console %> anywhere in the code.
  gem 'binding_of_caller'
  gem 'better_errors'
  gem 'web-console', '>= 3.3.0'
  gem 'listen', '~> 3.0.5'
  # Spring speeds up developmenDaniel will t by keeping your application running in the background. Read more: https://github.com/rails/spring
  gem 'spring'
  gem 'rack-mini-profiler'
  # gem 'solano'
  gem 'spring-watcher-listen', '~> 2.0.0'
  #https://devcenter.heroku.com/articles/ruby-memory-use
  gem 'derailed' #You can see how much memory your gems use at boot time through the derailed benchmark gem.
  gem 'lol_dba'
  # Comment out these four gems if you are NOT using Docker for development:
  gem 'hirb'
end

group :test do
  gem 'rspec'
  #gem 'rspec-rails'
  gem 'rspec-collection_matchers'
  gem 'rspec-retry'
  gem 'rspec-sidekiq'
  gem 'launchy'
  gem 'rails-controller-testing'
  # gem 'capybara', '~> 2.13.0'
  gem 'capybara'
  #gem 'database_cleaner'
  gem 'simplecov', :require => false
  gem 'cucumber-rails', '~> 2.2.0',  :require => false #Calculator Scenario Testing
  gem 'selenium-webdriver'
  gem 'vcr'
  gem 'webmock'
  gem 'site_prism'
  gem 'shoulda-matchers', github: 'thoughtbot/shoulda-matchers', branch: 'rails-5'  
  gem 'rspec_junit_formatter'
  gem 'rubocop-rspec'
  #gem 'ffaker'
  gem 'chromedriver-helper'
  gem 'capybara-webkit'
end

group :production do
  gem 'newrelic_rpm'
  # gem 'rails_12factor', '~> 0.0.3' #required by Heroku
  # gem 'pdftk-heroku', '0.0.4'
  gem 'rack-timeout' #Abort requests that are taking too long
end
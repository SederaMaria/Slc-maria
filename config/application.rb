require_relative 'boot'

require 'rails/all'

# Require the gems listed in Gemfile, including any gems
# you've limited to :test, :development, or :production.
Bundler.require(*Rails.groups)

module SpeedLeasing
  class Application < Rails::Application
    # Settings in config/environments/* take precedence over those specified here.
    # Application configuration should go into files in config/initializers
    # -- all .rb files in that directory are automatically loaded.

    config.generators do |g|
      g.template_engine :slim
      g.test_framework  :rspec, view_specs: false, routing_specs: false
      g.fixture_replacement :factory_bot, dir: 'spec/factories'
      g.assets = false
      g.helper = false
      g.skip_routes(true)
    end

    config.middleware.insert_before 0, Rack::Cors do
      allow do
        origins '*'
        resource '*', headers: :any, methods: [:get, :post, :put, :options, :patch, :delete]
      end
    end

    config.time_zone = 'Eastern Time (US & Canada)'

    config.active_record.schema_format = :ruby
    config.active_record.maintain_test_schema = true #this is not working???
    config.active_job.queue_adapter = Rails.env.production? ? :sidekiq : :async
    config.autoload_paths += %W( app/admin/concerns )
    config.middleware.insert_after ActionDispatch::Static, Rack::Deflater

  end
end

ActiveRecord::SessionStore::Session.serializer = :json
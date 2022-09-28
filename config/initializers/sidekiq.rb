require "action_mailer_auto_url_options/middleware/sidekiq"

Sidekiq.configure_server do |config|
  config.redis = { namespace: 'speed-leasing' }
end

Sidekiq.configure_client do |config|
  config.redis = { namespace: 'speed-leasing' }
  #config.redis = { url: ENV.fetch('REDISCLOUD_URL', ENV['REDIS_URL']) }
  #config.redis = { db: 0 }
end

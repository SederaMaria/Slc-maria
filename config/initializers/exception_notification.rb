require 'exception_notification/rails'
require 'exception_notification/sidekiq'

ExceptionNotification.configure do |config|
  # Ignore additional exception types.
  # ActiveRecord::RecordNotFound, Mongoid::Errors::DocumentNotFound, AbstractController::ActionNotFound and ActionController::RoutingError are already added.
  # config.ignored_exceptions += %w{ActionView::TemplateError CustomError}

  # Adds a condition to decide when an exception must be ignored or not.
  # The ignore_if method can be invoked multiple times to add extra conditions.
  config.ignore_if do |exception, options|
    exception.message =~ /bad content body/ ||
    exception.message =~ /Error code: E008/ ||
    exception.message =~ /Error code: E007/ ||
      !Rails.env.production?
  end

  # Notifiers =================================================================

  # Email notifier sends notifications by email.
  config.add_notifier :email, {
    :email_prefix         => "[#{ENV.fetch('HEROKU_APP_NAME', 'Speed Leasing').titleize} ERROR]",
    :sender_address       => %{"Speed Leasing Support" <#{ENV.fetch('SUPPORT_EMAIL', 'support@speedleasing.com')}>},
    :exception_recipients => ENV.fetch('EXCEPTION_RECIPIENTS', 'paulm@speedleasing.com').split(' ')
  }

  config.add_notifier :custom_slack, {
    :webhook_url => "https://hooks.slack.com/services/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",
    :channel => "#exceptions",
    :additional_parameters => {
      :mrkdwn => true,
    }
  }

  # Campfire notifier sends notifications to your Campfire room. Requires 'tinder' gem.
  # config.add_notifier :campfire, {
  #   :subdomain => 'my_subdomain',
  #   :token => 'my_token',
  #   :room_name => 'my_room'
  # }

  # HipChat notifier sends notifications to your HipChat room. Requires 'hipchat' gem.
  # config.add_notifier :hipchat, {
  #   :api_token => 'my_token',
  #   :room_name => 'my_room'
  # }

  # Webhook notifier sends notifications over HTTP protocol. Requires 'httparty' gem.
  # config.add_notifier :webhook, {
  #   :url => 'http://example.com:5555/hubot/path',
  #   :http_method => :post
  # }

end
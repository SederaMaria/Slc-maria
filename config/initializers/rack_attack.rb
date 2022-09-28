# https://github.com/rack/rack-attack#usage
# NOTE: To test in development, create a file tmp/caching-dev.txt and restart server

LIMIT_NON_GET_ACTIONS_PER_USER_SECONDS = ENV['RACK_THROTTLE_ADMIN_ACTIONS_SECONDS'].presence || 10

# Limit non-GET activeadmin actions per user (Dealer, AdminUser) and scecific request path; Limit 1 request per 10 seconds
Rack::Attack.throttle('LIMIT_NON_GET_ACTIONS_PER_USER', limit: 1, period: LIMIT_NON_GET_ACTIONS_PER_USER_SECONDS) do |request|
  unless request.get?
    if request.path.start_with?('/admins/')
      if request.env.dig("rack.session", "warden.user.admin_user.session", "unique_session_id").present?
        # Discriminator is {unique_session_id} {request.path}
        "#{request.env["rack.session"]["warden.user.admin_user.session"]["unique_session_id"]} #{request.path}"
      end
    elsif request.path.start_with?('/dealers/')
      if request.env.dig("rack.session", "warden.user.dealer.session", "unique_session_id").present?
        # Discriminator is {unique_session_id} {request.path}
        "#{request.env["rack.session"]["warden.user.dealer.session"]["unique_session_id"]} #{request.path}"
      end
    end
  end
end

def to_error_type(request)
  result = Rails.application.routes.recognize_path(request.path, method: request.request_method) rescue nil
  return URI.encode("controller#action") unless result
  return URI.encode("#{result[:controller]}##{result[:action]}")
end

# https://github.com/rack/rack-attack#customizing-responses
Rack::Attack.throttled_responder = lambda do |request|
  # TODO: Find a way to implement flash[:alert] here instead of redirection
  if request.path.start_with?('/admins/')
    headers = {
      'Location' => "/admins?error=dup-req&error_type=#{to_error_type(request)}",
    }

    [ 301, headers, [] ]
  elsif request.path.start_with?('/dealers/')
    headers = {
      'Location' => "/dealers?error=dup-req&error_type=#{to_error_type(request)}",
    }

    [ 301, headers, [] ]
  else
    [ 503, {}, ["Server Error\n"] ]
  end
end

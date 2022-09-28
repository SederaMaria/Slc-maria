# # File: config/initializers/json_param_key_transform.rb
# # Transform JSON request param keys from JSON-conventional camelCase to
# # Rails-conventional snake_case:
# ActionDispatch::Request.parameter_parsers[:json] = lambda { |raw_post|
#   # Modified from action_dispatch/http/parameters.rb
#   data = ActiveSupport::JSON.decode(raw_post)

#   # Transform camelCase param keys to snake_case
#   if data.is_a?(Array)
#     data.map { |item| item.transform_keys!(&:underscore) }
#   else
#     data.transform_keys!(&:underscore)
#   end
  
#   Rails.logger.debug data.inspect

#   # Return data
#   data.is_a?(Hash) ? data : { '_json': data }
# }
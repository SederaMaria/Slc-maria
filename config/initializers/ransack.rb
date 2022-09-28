#https://github.com/activerecord-hackery/ransack#using-scopesclass-methods
Ransack.configure do |c|
  c.sanitize_custom_scope_booleans = false
end
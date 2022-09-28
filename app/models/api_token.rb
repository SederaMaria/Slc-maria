class ApiToken < ApplicationRecord
  require 'bcrypt'
  has_secure_token :access_token

  def self.generate_auth_token(name)
    token = Digest::SHA1.hexdigest("--#{ BCrypt::Engine.generate_salt }--")
    create(name: name, access_token: token, access_token_created_at: Time.zone.now)
    token
  end

end

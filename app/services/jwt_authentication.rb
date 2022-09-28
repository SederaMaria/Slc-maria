class JwtAuthentication
  SCOPES = %w[signature impersonation].freeze
  DOCUSIGN_PRIVATE_KEY_PATH = File.join(Rails.root, 'config', (Rails.env.development? || ENV['HEROKU_APP_NAME'].include?('staging')) ? 'docusign_private.key' : 'docusign_private_production.key')

  attr_reader :jwt_integration_key, :jwt_user_guid, :jwt_server

  def initialize
    @jwt_integration_key = ENV['JWT_INTEGRATION_KEY']
    @jwt_user_guid = ENV['JWT_USER_GUID']
    @jwt_server = ENV['JWT_AUTHORIZATION_SERVER']
  end

  def authenticate
    configuration = DocuSign_eSign::Configuration.new
    configuration.debugging = true
    api_client = DocuSign_eSign::ApiClient.new(configuration)
    api_client.set_oauth_base_path(jwt_server)

    begin
      token = api_client.request_jwt_user_token(jwt_integration_key, jwt_user_guid, DOCUSIGN_PRIVATE_KEY_PATH, expires_in=3600, SCOPES)
      user_info_response = api_client.get_user_info(token.access_token)
      account = user_info_response.accounts.find(&:is_default)

      account_info = {
        access_token: token.access_token,
        account_id: account.account_id,
        base_path: account.base_uri
      }
      Rails.cache.write("docusign_jwt_token", account_info, expires_in: 3600)
      account_info
    rescue OpenSSL::PKey::RSAError => exception
      Rails.logger.error exception.inspect
      if File.read(DOCUSIGN_PRIVATE_KEY_PATH).starts_with? '{RSA_PRIVATE_KEY}'
        fail "Please add your private RSA key to: #{DOCUSIGN_PRIVATE_KEY_PATH}"
      else
        raise
      end
    rescue DocuSign_eSign::ApiError => exception
      body = JSON.parse(exception.response_body)
      if body['error'] == "consent_required"
        authenticate if get_consent
      else
        puts "API Error"
        puts body['error']
        puts body['message']
        exit
      end
    end
  end

  def get_consent
    url_scopes = SCOPES.join('+');
    # redirect_uri = "https://developers.docusign.com/platform/auth/consent";
    redirect_uri = Rails.env.development? || Rails.env.staging? ? 'http://localhost:3000/' : 'https://admin2.speedleasing.com/'
    consent_url = "https://#{@jwt_server}/oauth/auth?response_type=code&" +
      "scope=#{url_scopes}&client_id=#{@jwt_integration_key}&" +
      "redirect_uri=#{redirect_uri}"

    Rails.logger.info "==> Obtain Consent Grant required: #{consent_url}"
    Rails.logger.info "Consent granted? \n 1)Yes \n 2)No"
    continue = gets;
    if continue.chomp == "1"
      return true;
    else
      Rails.logger.info "Please grant consent"
      exit
    end
  end
end

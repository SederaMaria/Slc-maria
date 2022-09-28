module ESign
  class AuthenticationFacade
    attr_reader :e_sign_type

    class ESignAuthenticationErrors < StandardError
      def initialize(type, error)
        @type = type
        @error = error
      end

      def to_s
        "ESign Authentication failed for #{@type}. Reason: #{@error}"
      end
    end

    def initialize(args)
      @args = args
      @e_sign_type = args[:e_sign_type]
    end

    def authenticate
      case e_sign_type
      when 'docusign'
        jwt_authentication
      else
        raise ESignAuthenticationErrors.new(e_sign_type, 'Not a valid ESign Type')
      end
    end

    private

    # jwt authentication for docusign
    def jwt_authentication
      token_from_cache = load_token_from_cache
      token_from_cache.present? ? token_from_cache : JwtAuthentication.new.authenticate
    end

    def load_token_from_cache
      Rails.cache.read("docusign_jwt_token")
    end
  end
end

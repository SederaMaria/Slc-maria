module ESign
  class ESignFacade
    attr_reader :args, :authentication, :e_sign_type, :e_sign_service

    class ESignServiceErrors < StandardError
      def initialize(type, error)
        @type = type
        @error = error
      end

      def to_s
        "ESign Service failed for #{@type}. Reason: #{@error}"
      end
    end

    def initialize(args)
      @args = args
      @authentication = AuthenticationFacade.new(args).authenticate
      @e_sign_type = args[:e_sign_type]
      @e_sign_service = handle_e_sign_service
    end

    def handle_e_sign_service
      case e_sign_type
      when 'docusign'
        docusign_service
      else
        raise ESignServiceErrors.new(e_sign_type, 'Not a valid ESign Type')
      end
    end

    def docusign_service
      ESign::SigningViaEmailService.new({ envelope_args: args }.merge(authentication))
    end

    def create
      e_sign_service.worker
    end

    def resend
      e_sign_service.resend_envelope
    end

    def void
      e_sign_service.void_envelope
    end

    def get_status
      e_sign_service.get_envelope_status
    end

    def import_remote_envelopes
      e_sign_service.import_docusign_envelopes
    end
  end
end

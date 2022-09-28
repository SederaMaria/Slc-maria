module SimpleAudit
  module Custom
    module ActiveAdminComment
      extend ::ActiveSupport::Concern

      included do
        def creation_audit
          build_audit_entry(creates_builder)
        end

        def creates_builder
          "#{embolden('Created')} a comment"
        end
      end
    end
  end
end

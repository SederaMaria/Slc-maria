module SimpleAudit
  module Custom
    module LeaseApplicationUnderwritingReview
      extend ::ActiveSupport::Concern

      included do
        def creation_audit
          build_audit_entry(creates_builder)
        end

        def creates_builder
          "#{embolden('Changed')} this #{embolden('Workflow Status')} to #{embolden(self.workflow_status.description)} with #{embolden('Comments')} set to #{embolden(self.comments)}"
        end
      end
    end
  end
end

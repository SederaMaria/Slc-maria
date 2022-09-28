module SimpleAudit
    module Custom
      module IncomeVerification
        extend ::ActiveSupport::Concern
  
        included do
          def deletion_audit
            build_audit_entry(deletes_builder)
          end
  
          def deletes_builder
            string = "#{embolden('Deleted')} #{class_name} with #{embolden(self.id)} created at #{embolden(self.created_at)}"
            string
          end
        end
      end
    end
end
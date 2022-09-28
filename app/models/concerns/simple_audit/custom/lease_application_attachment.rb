module SimpleAudit
    module Custom
      module LeaseApplicationAttachment
        extend ::ActiveSupport::Concern
  
        included do
          def deletion_audit
            build_audit_entry(deletes_builder)
          end
  
          def deletes_builder
            string = "#{embolden('Deleted')} #{class_name} with #{embolden(self.upload.identifier)} created at #{embolden(self.created_at)}"
            string
          end
        end
      end
    end
end
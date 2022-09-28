module SimpleAudit
  module Custom
    module LeaseApplicationStipulation
      extend ::ActiveSupport::Concern

      included do
        def update_audit
          build_audit_entry(updates_builder + attributes_builder) if updates_builder.present?
        end

        def attributes_to_display
          @attributes_to_display ||=
            (attributes.keys - saved_changes.keys - attributes_to_skip)
        end

        def attributes_builder
          # need to match the ActiveRecord::Dirty hash
          # key => [<previous value>, <new value>]
          attributes_to_build =
            attributes.slice(*attributes_to_display).inject({}) do |hash, (k, v)|
              hash[k] = [nil, v]; hash
            end
          string              = ' with ' + attribute_changes(attributes_to_build, true)
          string
        end
      end
    end
  end
end

module SimpleAudit
  module Custom
    module Lessee
      extend ::ActiveSupport::Concern

      included do
        def association_reader(key, id)
          return if id.nil?
          fk = associated_attribute_fk(key) || :id
          klass = klassify(key.gsub('_id', '')).find_by({ fk => id })
          result = klass.read_attribute(associated_attribute(key))
          return key.eql?('employment_status') ? result.try(:humanize) : result
        end
      end
    end
  end
end

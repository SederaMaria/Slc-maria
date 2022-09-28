module SimpleAudit
  module Model
    ASSOCIATIONS_TO_TRACK = {
      'LeaseApplicationStipulation': {
        stipulation_id:                  'description',
        lease_application_attachment_id: 'upload'
      },
      'IncomeVerification': {
        income_verification_type_id: 'income_verification_name',
        income_frequency_id: 'income_frequency_name'
      },
      'Lessee': {
        employment_status: 'definition',
        employment_status_fk: 'employment_status_index'
      }
    }

    def self.included(base)
      base.send :extend, ClassMethods
    end

    module ClassMethods
      extend ::ActiveSupport::Concern

      def simple_audit(options = {})
        const_set('IS_CHILD', !!options[:child].presence)
        include SimpleAudit::ModelSetup
        include ActionView::Helpers::NumberHelper
      end
    end
  end

  module ModelSetup
    extend ::ActiveSupport::Concern

    included do
      has_many :audits, as: :audited

      after_commit :creation_audit, on: :create
      after_commit :update_audit, on: :update, if: :has_changes?
      before_destroy :deletion_audit

      def has_changes?
        saved_changes.present?
      end

      def creation_audit
        if class_name == 'Docusign Summary'
          build_audit_entry(creates_builder_for_docusign)
        else
          build_audit_entry(creates_builder)
        end
      end

      def update_audit
        build_audit_entry(updates_builder) if updates_builder.present?
      end

      def creates_builder
        string         = "#{embolden('Created')} this #{class_name}"
        create_changes = attribute_changes(saved_changes, true)
        string         += " with #{create_changes}" unless create_changes.blank?
        string
      end

      def creates_builder_for_docusign
        string         = "#{embolden('Created')} Docusign Envelope"
        if saved_changes['envelope_id'].present?
          envelope_id = saved_changes['envelope_id'].last
          string         += " with #{embolden('ID')}: #{envelope_id}"
        end
        string
      end

      def updates_builder
        update_changes = attribute_changes(saved_changes)
        return if update_changes.blank?
        string = "Changed #{update_changes}"
        string += " with #{embolden('Envelope ID')}: #{self.envelope_id}" if class_name == 'Docusign Summary'
        string
      end

      def attribute_changes(changes_hash, creation = false, last_element = nil)
        attribute_changes = build_changes(changes_hash, creation)
        last_element      = attribute_changes.pop if attribute_changes.size > 1

        return unless attribute_changes.any?
        string = "#{attribute_changes.join(', ')}"
        string += ", and #{last_element}" if last_element
        string
      end

      def build_changes(changes_hash, creation = false)
        changes_hash.collect do |key, values|
          next if attributes_to_skip.include?(key)
          next if key.include?('_id') && no_associations_to_track?(key)
          changed_from_val = values[0]
          changed_to_val   = values[1]

          if creation
            next if value_reader(key, changed_to_val).eql?('nil')
            if has_associations_to_track?(key)
              "#{key_reader(key)} set to #{value_reader(key, association_reader(key, changed_to_val))}"
            else
              "#{key_reader(key)} set to #{value_reader(key, changed_to_val)}"
            end
          else
            if has_associations_to_track?(key)
              "#{key_reader(key)} from #{value_reader(key, association_reader(key, changed_from_val))} to #{value_reader(key, association_reader(key, changed_to_val))}"
            else
              "#{key_reader(key)} from #{value_reader(key, changed_from_val)} to #{value_reader(key, changed_to_val)}"
            end
          end
        end.compact
      end

      def associations_to_track
        self.class::ASSOCIATIONS_TO_TRACK[self.class.to_s.to_sym]
      end

      def no_associations_to_track?(key)
        !has_associations_to_track?(key)
      end

      def has_associations_to_track?(key)
        return false if associations_to_track.nil?
        keys = associations_to_track.keys
        return false if keys.empty?
        keys.include?(key.to_sym)
      end

      def associated_attribute(key)
        associations_to_track[key.to_sym]
      end

      # If a foreign key used is not conventional.
      # You can assign the fk on the same key name + '_fk'; example:
      #
      # ```
      # {
      #   'ModelName': {
      #     column_name: 'foreign_attribute'
      #     column_name_fk: 'foreign_key'
      #   }
      # }
      # ```
      def associated_attribute_fk(key)
        associations_to_track[("#{key}_fk").to_sym]
      end

      def key_reader(key)
        embolden(human_readable(key.gsub('_id', '')))
      end

      def value_reader(key, value)
        value = value.to_s
        return 'nil' if value.empty?
        value = dollarify(value) if key.to_s.include? '_cents'
        embolden(value)
      end

      def dollarify(cents)
        "$#{number_with_precision(Money.new(cents).dollars, precision: 2)}"
      end

      def association_reader(key, id)
        return if id.nil?
        pk_or_fk = associated_attribute_fk(key) || :id
        klass = klassify(key.gsub('_id', '')).find_by({ pk_or_fk => id })
        klass.read_attribute(associated_attribute(key))
      end

      def is_child?
        self.class::IS_CHILD
      end

      def build_audit_entry(audited_changes)
        attributes = { audited_changes: audited_changes }
        attributes.merge!(auditor) if auditor
        attributes.merge!(parent_type: 'LeaseApplication', parent_id: parent_lease_application.id) if is_child? && parent_lease_application
        self.audits.create(attributes)
      end

      def parent_lease_application
        return unless is_child?
        @parent ||=
          case self.class.to_s
            when 'Lessee', 'LeaseCalculator', 'LeaseApplicationStipulation', 'Insurance', 'OnlineFundingApprovalChecklist', 'LeaseApplicationUnderwritingReview','LeaseApplicationAttachment', 'DocusignSummary'
              self.lease_application
            when 'Address'
              lessee = Lessee.where(employment_address_id: self.id).or(Lessee.where(home_address_id: self.id)).or(Lessee.where(mailing_address_id: self.id)).first
              lessee.try(:lease_application)
            when 'IncomeVerification'
              lessee = Lessee.find_by(id: self.lessee_id)
              lessee.try(:lease_application)
            when 'CreditReport'
              self.lessee&.lease_application
            when 'ActiveAdminComment'
              self.resource_type.eql?('LeaseApplication') ? self.resource : nil
          end
      end

      def attributes_to_skip
        %w(id created_at updated_at encrypted_ssn encrypted_ssn_iv ssn auth_token_created_at last_request_at credco_xml)
      end

      def auditor
        @auditor ||= Store.auditor
      end

      def embolden(string)
        "<strong>#{string}</strong>"
      end

      def class_name
        human_readable(self.class.to_s)
      end

      def human_readable(string)
        build_klass_string(string).join(' ')
      end

      def klassify(string)
        build_klass_string(string).join('').constantize
      end

      def build_klass_string(string)
        string.underscore.split('_').collect { |c| c.capitalize }
      end
    end
  end
end

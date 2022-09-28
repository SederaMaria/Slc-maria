#For compatibility with LeasePackageDocument Generator code without the need to
#  reprogram the Generator mappings
module LeaseApplications
  module LeasePackageDocumentMethods
    def gap_contract_term
      last_lease_document_request&.gap_contract_term
    end
    deprecate :gap_contract_term

    def tire_wheel_contract_term
      last_lease_document_request&.tire_contract_term
    end
    deprecate :tire_wheel_contract_term

    def esp_contract_term
      last_lease_document_request&.service_contract_term
    end
    deprecate :esp_contract_term
    
    def ppm_contract_term
      last_lease_document_request&.ppm_contract_term
    end
    deprecate :ppm_contract_term

    def ext_svc
      lease_calculator.extended_service_contract_cost
    end
    deprecate :ext_svc

    def ppmt
      lease_calculator.prepaid_maintenance_cost
    end
    deprecate :ppmt

    def term
      lease_calculator.term
    end
    deprecate :term

    def check_if_any_contract_exists?
      lease_calculator.extended_service_contract_cost_cents > 0
    end
    deprecate :check_if_any_contract_exists?

    def reference1
      references.first
    end
    deprecate :reference1

    def reference2
      references.offset(1).first
    end
    deprecate :reference2

    def reference3
      references.offset(2).first
    end
    deprecate :reference3

    def reference4
      references.offset(3).first
    end
    deprecate :reference4
  end
end
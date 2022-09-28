class LeaseManagementSystem < ApplicationRecord
    belongs_to :lease_management_system_document_status


    def document_status
        lease_management_system_document_status&.value
    end

end

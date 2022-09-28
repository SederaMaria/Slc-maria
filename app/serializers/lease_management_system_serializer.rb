class LeaseManagementSystemSerializer < ApplicationSerializer
    attributes :id, :send_leases_to_lms, :api_destination, :lease_management_system_document_status_id, :document_status_options

    def send_leases_to_lms
        object&.send_leases_to_lms ? 1 : 0
    end


    def document_status_options
        LeaseManagementSystemDocumentStatus.all.map{ |i|  
            {
                label: i.description,
                value: i.id,
                disabled: false
            }
        }
        
    end
    
  end
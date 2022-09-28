namespace :lease_management_system do
    desc 'Seed Lease Management System'
    task seed_document_status: :environment do
      if LeaseManagementSystemDocumentStatus.all.empty?
        seed_document_status.each do |seed|
            LeaseManagementSystemDocumentStatus.create(seed)
        end
      end
    end
    
    def seed_document_status
      [
        { value: 'lease_package_received',	description: "Lease Package Received" },
        { value: 'funding_approved',	description: "Funding Approved" },
        { value: 'funded',	description: "Funded" }
      ]
    end
    
    
  
    desc 'Create Lease Management System'
    task create: :environment do
      if LeaseManagementSystem.all.empty?
        LeaseManagementSystem.create(api_destination: 'https://', send_leases_to_lms: false)
      end
    end

  end
  
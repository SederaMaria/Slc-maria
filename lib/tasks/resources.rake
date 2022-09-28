namespace :resources do

  desc 'Seed Resources'
  task seed: :environment do
    if Resource.all.empty?
      resource_seed.each do |seed|
        Resource.create(seed)
      end
    end
  end
  
  def resource_seed
    [
      { is_active: true, name: "AdminUser" },
      { is_active: true, name: "CreditTier" },
      { is_active: true, name: "Dealership" },
      { is_active: true, name: "ModelGroup" },
      { is_active: true, name: "VehicleInventory" },
    ]
  end

  desc 'Create a new resource for Welcome Calls'
  task create_welcome_call: :environment do 
    Resource.create({name: "WelcomeCall", is_active: true})
  end

  desc 'Create new resources for Employment Verifications and Dealership Approval'
  task create_emp_verify_and_dealership_approval: :environment do 
    Resource.create({name: "EmploymentVerification", is_active: true})
    Resource.create({name: "DealershipSalesRecommendation", is_active: true})
    Resource.create({name: "DealershipUnderwritingApproval", is_active: true})
    Resource.create({name: "DealershipCreditCommitteeApproval", is_active: true})
  end

  desc 'Create new resources for Lease Application Underwriting Review and Approval'
  task create_lease_workflow_underwriting: :environment do 
    Resource.create({name: "LeaseWorkflowUnderwritingReview", is_active: true})
    Resource.create({name: "LeaseWorkflowUnderwritingApprove", is_active: true})
  end

  desc 'Create new resource for Lease Application Vehicle Possession'
  task create_lease_vehicle_possession: :environment do 
    Resource.create({name: "LeaseVehiclePossession", is_active: true})
  end

end
namespace :workflow_status do
  desc 'Seed workflow status'
  task seed: :environment do
    if WorkflowStatus.all.empty?
      workflow_status_seed.each do |seed|
        WorkflowStatus.create(seed)
      end
    end
    
  end
  
  def workflow_status_seed
    [
      { active: true,	description: "Application" },
      { active: true,	description: "Underwriting" },
      { active: true,	description: "Underwriting Review" },
      { active: true,	description: "Verification" },
      { active: true,	description: "Funding" },
      { active: true,	description: "Done" }
    ]
  end

  desc 'Add workflow Approved'
  task add_approved: :environment do
    unless WorkflowStatus.all.empty?
      WorkflowStatus.create({active: true, description: "Underwriting Approved"})
    end
  end

end

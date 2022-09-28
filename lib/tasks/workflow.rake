namespace :workflow do
    desc 'Seed Workflow'
    task seed: :environment do
      if Workflow.all.empty?
        Workflow.create(workflow_name: "Dealership Onboarding")
      end
    end

    desc 'Seed Workflow Settings'
    task seed_settings: :environment do
      if WorkflowSetting.all.empty?
        workflow_settigs_seed.each do |seed|
            WorkflowSetting.create(seed)
        end
      end
    end
  

    desc 'Seed Workflow Underwriting'
    task seed_underwriting: :environment do
      workflow_name = 'Underwriting'
      if Workflow.where(workflow_name: workflow_name).empty?
        Workflow.create(workflow_name: workflow_name)
      end
    end

    desc 'Seed Workflow Settings for Underwriting'
    task seed_settings_underwriting: :environment do
      workflow_settigs_seed_underwriting.each do |seed|
        if WorkflowSetting.where(workflow_setting_name: seed['workflow_setting_name']).empty?
          WorkflowSetting.create(seed)
        end
      end
    end

    private 

    def workflow_settigs_seed
        dealership_onboarding = Workflow.find_by(workflow_name: "Dealership Onboarding")
        [
          { workflow_id: dealership_onboarding.id, workflow_setting_name: "Sales Approvers" },
          { workflow_id: dealership_onboarding.id, workflow_setting_name: "Operations Approvers" },
          { workflow_id: dealership_onboarding.id, workflow_setting_name: "Notify Operations Approvers" },
          { workflow_id: dealership_onboarding.id, workflow_setting_name: "Not Notify Operations Approvers" },
          { workflow_id: dealership_onboarding.id, workflow_setting_name: "Final Approvers" },
          { workflow_id: dealership_onboarding.id, workflow_setting_name: "Notify Final Approvers" },
          { workflow_id: dealership_onboarding.id, workflow_setting_name: "Not Notify Final Approvers" },
        ]
    end

    def workflow_settigs_seed_underwriting
      underwriting = Workflow.find_by(workflow_name: 'Underwriting')
      [
        { workflow_id: underwriting.id, workflow_setting_name: 'Underwriting Reviewers' },
        { workflow_id: underwriting.id, workflow_setting_name: 'Notify Requested Review' },
        { workflow_id: underwriting.id, workflow_setting_name: 'Not Notify Requested Review' },
      ]
    end

  end
  
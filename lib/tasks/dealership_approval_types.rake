namespace :dealership_approval_types do
    desc 'Seed Approval types'
    task seed: :environment do
      if DealershipApprovalType.all.empty?
        approval_types_seed.each do |ds|
            DealershipApprovalType.create(ds)
        end
      end
      
    end
  
    def approval_types_seed
      [
        { active: true,	description: "Sales" },
        { active: true,	description: "Operations" },
        { active: true,	description: "Final" }
      ]
    end

    desc 'Change Operations to Underwriting'
    task change_ops_to_underwriting: :environment do
      DealershipApprovalType.where(description: 'Operations').update_all(description: 'Underwriting')
    end

    desc 'Change Final to Credit Committee'
    task change_final_to_credit_committee: :environment do
      DealershipApprovalType.where(description: 'Final').update_all(description: 'Credit Committee')
    end
end
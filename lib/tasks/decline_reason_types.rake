namespace :decline_reason_types do
    desc "Seed decline reasons"
    task seed_decline_reason_types: :environment do
      seed_decline_reason_types.each do |seed|
        DeclineReasonType.create(seed)
      end
    end
    
    def seed_decline_reason_types
      [
        { decline_reason_name: "Bankruptcy in the Last Year" },
        { decline_reason_name: "Auto/Motorcycle Charge Off in the Last 3 Years" },
        { decline_reason_name: "Foreclosure in the Last 3 Years" },
        { decline_reason_name: "Repossession in the Last 3 Years" },
        { decline_reason_name: "Poor Performance with Speed Leasing" },
        { decline_reason_name: "No Score with Derogatory Credit" },
        { decline_reason_name: "Thin File with Derogatory Credit" },
        { decline_reason_name: "All Trade Lines Reported Derogatory" },
      ]
    end
  
  end
  
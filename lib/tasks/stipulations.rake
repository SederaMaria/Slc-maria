namespace :stipulations do
  desc "Add pre and post Income Stipulations"
  task pre_post_income_stipulation: :environment do 
    Stipulation.all.each do |stipulation|
      if stipulation.description == "May be subject to payment limit (send POI, and we'll determine the exact limit, if any)"
        stipulation.pre_income_stipulation = true
        stipulation.save
      end
      if stipulation.description == "Maximum Monthly Payment Limited to $"
        stipulation.post_income_stipulation = true
        stipulation.save
      end
    end
   end

   desc "Require Stipulations"
   task require: :environment do 
     Stipulation.all.each do |stipulation|
      stipulation.required = true
      stipulation.save
     end
    end


    desc "Set post_submission"
    task set_post_submission: :environment do 
      Stipulation.where(abbreviation: ['POR','POI','PayLmt?','4Refs','VC']).each do |stipulation|
       stipulation.post_submission_stipulation = true
       stipulation.save
      end
     end


     desc 'Seed credit tiers'
     task seed_credit_tier_type: :environment do
       if StipulationCreditTierType.all.empty?
         seed_credit_tier.each do |seed|
             StipulationCreditTierType.create(seed)
         end
       end
     end

     desc "Set all stipulations into inactive"
      task set_old_stips_to_inactive: :environment do
        Stipulation.update_all(active: false, post_submission_stipulation: false)
    end

    desc 'Seed new stipulations 03042022'
     task seed_active03042022: :environment do
         seed_active03042022.each do |seed|
             Stipulation.create(seed)
       end
    end

     private 
     def seed_credit_tier
       [
         { description: 'Tier 1', position: 1},
         { description: 'Tier 2', position: 2},
         { description: 'Tier 3', position: 3},
         { description: 'Tier 4', position: 4},
         { description: 'Tier 5', position: 5},
         { description: 'Tier 6', position: 6},
         { description: 'Tier 7', position: 7},
         { description: 'Tier 8', position: 8},
         { description: 'Tier 9', position: 9},
         { description: 'Tier 10', position: 10},
       ]
     end

     def seed_active03042022
      [
        { description: 'Application requires additional information', abbreviation: 'NA' },
        { description: 'Proof of stated income prior to documentation, may be subject to payment limit after review', abbreviation: 'NA' },
        { description: 'Proof of residence matching application prior to documentation', abbreviation: 'NA' },
        { description: 'Proof of social security number and photo ID prior to documentation', abbreviation: 'NA' },
        { description: 'Proof of Account(s) paid current prior to documentation', abbreviation: 'NA' },
        { description: 'Proof of satisfaction on liens/judgment prior to documentation', abbreviation: 'NA' },
        { description: 'Other', abbreviation: 'NA' },
        { description: 'GPS required prior to funding', abbreviation: 'NA' },
        { description: 'Subject to pre-funding verification call(s)', abbreviation: 'NA' },
        { description: 'Payoff of existing Speed Lease(s) prior to funding', abbreviation: 'NA' },
        { description: 'Proof of payoff prior to funding', abbreviation: 'NA' },
        { description: 'Does not qualify for this bike, please contact us for help selecting a bike they will qualify for. 844-390-0717 option # 1', abbreviation: 'NA' },
        { description: 'Maximum monthly payment limited to $', abbreviation: 'NA' },
        { description: 'Applicant has another open approval, only one can fund', abbreviation: 'NA' },
        { description: 'Recent Repossession/Charge off/Foreclosure', abbreviation: 'NA' },
        { description: 'Recent Bankruptcy', abbreviation: 'NA' },
        { description: 'Poor performance with Speed Leasing', abbreviation: 'NA' },
        { description: 'Applicant does not meet current underwriting guidelines', abbreviation: 'NA' },
      ]
     end


 end
 
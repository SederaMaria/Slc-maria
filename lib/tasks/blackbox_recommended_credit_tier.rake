namespace :blackbox_recommended_credit_tier_168457676 do
  desc 'Seed Datax Recommended Credit Tier '
  task seed: :environment do
    LeaseApplicationBlackboxRequest.all.each do |blackbox|
      recommended_credit_tier = LeaseApplication.credit_tier_range(blackbox.leadrouter_credit_score.to_i)
      credit_tier = CreditTier.all.select{|c| c.description.split(' ')[1].to_i == recommended_credit_tier }.first
      blackbox.create_recommended_credit_tier(credit_tier_id: credit_tier&.id)
    end
  end
end

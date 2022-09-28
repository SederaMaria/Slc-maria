namespace :suggested_credit_tier_168457613 do
 desc "Seed Suggested Credit tier"
 task seed: :environment do 
   CreditReport.all.each do |credit_report|
     if credit_report.recommended_credit_tier.nil?
       recommended_credit_tier = LeaseApplication.credit_tier_range(credit_report.lessee.highest_fico_score)
       credit_tier = CreditTier.all.select{|c| c.description.split(' ')[1].to_i == recommended_credit_tier }.first
       credit_report.create_recommended_credit_tier(lessee_id: credit_report.lessee_id, credit_tier_id: credit_tier&.id)
     end
   end
  end
end

namespace :credit_tier_effective_end_date_168413113 do
  desc 'Seed effective date and end date to credit tiers'
  task seed: :environment do
    unless CreditTier.all.empty?
      CreditTier.all.each do |credit|
        credit.effective_date = "1/1/2017".to_date
        credit.end_date = "12/31/2999".to_date
        credit.save
      end
    end
  end
end

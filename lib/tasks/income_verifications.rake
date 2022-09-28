namespace :income_verifications do
  desc "Seed `IncomeFrequency` and `IncomeVerificationType`"
  task :seed => [:environment] do
    ['1099', 'Paystub', 'W2', 'Bank Statements','Other'].each do |value|
      IncomeVerificationType.where(income_verification_name: value).first_or_create!
    end

    ['Weekly', 'Bi-Weekly', 'Monthly', 'Yearly'].each do |value|
      IncomeFrequency.where(income_frequency_name: value).first_or_create!
    end
  end
end

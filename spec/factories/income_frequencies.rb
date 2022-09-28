FactoryBot.define do
  factory :income_frequency do
    income_frequency_name { 'Weekly' }

    trait :random do
      income_frequency_name { ['Weekly', 'Bi-Weekly', 'Monthly', 'Yearly'].sample }
    end

    trait :weekly  do
      income_frequency_name { 'Weekly' }
    end

    trait :bi_weekly  do
      income_frequency_name { 'Bi-Weekly' }
    end

    trait :monthly  do
      income_frequency_name { 'Monthly' }
    end

    trait :yearly  do
      income_frequency_name { 'Yearly' }
    end

    # Sample: `create(:random_income_frequency)`
    factory :random_income_frequency, traits: [:random]
    factory :weekly_income_frequency, traits: [:weekly]
    factory :bi_weekly_income_frequency, traits: [:bi_weekly]
    factory :monthly_income_frequency, traits: [:monthly]
    factory :yearly_income_frequency, traits: [:yearly]
  end
end

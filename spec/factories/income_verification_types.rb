FactoryBot.define do
  factory :income_verification_type do
    income_verification_name { '1099' }

    trait :random do
      income_verification_name { ['1099', 'Paystub', 'W2', 'Bank Statements' 'Other'].sample }
    end

    trait :ten99 do
      income_verification_name { '1099' }
    end

    trait :paystub do
      income_verification_name { 'Paystub' }
    end

    trait :w2 do
      income_verification_name { 'W2' }
    end

    trait :w2 do
      income_verification_name { 'Bank Statements' }
    end

    trait :other do
      income_verification_name { 'Other' }
    end

    # Sample: `create(:random_income_verification_type)`
    factory :random_income_verification_type, traits: [:random]
    factory :ten99_income_verification_type, traits: [:ten99]
    factory :paystub_income_verification_type, traits: [:paystub]
    factory :w2_income_verification_type, traits: [:w2]
    factory :bank_statements_income_verification_type, traits: [:bank_statements]
    factory :other_income_verification_type, traits: [:other]
  end
end

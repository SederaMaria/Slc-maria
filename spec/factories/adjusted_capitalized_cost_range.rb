FactoryBot.define do
  factory :adjusted_capitalized_cost_range do
    credit_tier
    acquisition_fee_cents { random_number }
    adjusted_cap_cost_lower_limit { random_number }
    adjusted_cap_cost_upper_limit { random_number }
    effective_date { Date.today }
    end_date { Date.today + 1.year }
  end
end

def random_number
  (1..10000).to_a.sample
end


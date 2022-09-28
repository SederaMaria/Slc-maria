FactoryBot.define do
  factory :funding_delay_reason, aliases: [:funding_delays_reason] do
    reason { FFaker::BaconIpsum.sentence }
  end
end

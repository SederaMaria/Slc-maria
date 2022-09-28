class StipulationCreditTier < ApplicationRecord
    belongs_to :stipulation
    belongs_to :stipulation_credit_tier_type
end

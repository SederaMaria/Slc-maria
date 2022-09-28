class LesseeRecommendedBlackboxTier < ApplicationRecord
    belongs_to :lessee
    belongs_to :blackbox_model_detail
    belongs_to :lease_application_blackbox_request
end

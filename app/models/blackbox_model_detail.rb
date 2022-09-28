class BlackboxModelDetail < ApplicationRecord
    belongs_to :blackbox_model

    scope :tier, ->(score) { where(blackbox_model_id: BlackboxModel.default_model.id ).where('? > credit_score_greater_than AND ? <= credit_score_max', score, score).first }

    def tier_label
        return "" if blackbox_tier.nil?
        "Tier #{blackbox_tier}"
    end


end

class LeaseApplicationRecommendedBlackboxTier < ApplicationRecord
    belongs_to :lease_application
    belongs_to :blackbox_model_detail
    belongs_to :lessee_lease_application_blackbox_request, class_name: 'LeaseApplicationBlackboxRequest'
    belongs_to :colessee_lease_application_blackbox_request, class_name: 'LeaseApplicationBlackboxRequest'


    def average_score
        blackboox_credit_scores = [
            lessee_lease_application_blackbox_request&.leadrouter_credit_score,
            colessee_lease_application_blackbox_request&.leadrouter_credit_score,
          ].compact.select{|x| x != 0 }
        return nil if blackboox_credit_scores.count.zero? || blackboox_credit_scores.sum.zero?
        (blackboox_credit_scores.sum / blackboox_credit_scores.count)&.round
    end

end

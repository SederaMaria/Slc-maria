class LeaseApplicationRecommendedCreditTier < ApplicationRecord
    belongs_to :credit_tier
    belongs_to :lease_application
    belongs_to :lessee_credit_report, class_name: 'CreditReport'
    belongs_to :colessee_credit_report, class_name: 'CreditReport'


  def average_score
    return 0 if lessee_credit_report.nil?
    scores = []
    value = 0
    scores << lessee_credit_report&.credit_score_equifax << lessee_credit_report&.credit_score_experian << lessee_credit_report&.credit_score_transunion
    if colessee_credit_report.present?
        scores << colessee_credit_report&.credit_score_equifax << colessee_credit_report&.credit_score_experian << colessee_credit_report&.credit_score_transunion
    end
    non_zero_scores = scores.compact.reject(&:zero?)
    unless non_zero_scores.blank? || non_zero_scores.size.zero?
      value = (non_zero_scores.sum.to_f / non_zero_scores.size.to_f).round
    end
    value
  end

end

# == Schema Information
#
# Table name: credit_reports
#
#  id                      :bigint(8)        not null, primary key
#  status                  :string
#  upload                  :string
#  identifier              :string
#  visible_to_dealers      :boolean
#  lessee_id               :bigint(8)
#  record_errors           :jsonb
#  created_at              :datetime         not null
#  updated_at              :datetime         not null
#  sidekiq_retry_count     :integer          default(0)
#  effective_date          :datetime
#  end_date                :datetime
#  credit_score            :integer
#  credit_score_equifax    :integer
#  credit_score_experian   :integer
#  credit_score_transunion :integer
#  credit_score_average    :integer
#
# Indexes
#
#  index_credit_reports_on_lessee_id  (lessee_id)
#

FactoryBot.define do
  factory :credit_report do
    association :lessee
  end
end

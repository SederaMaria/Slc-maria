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

class CreditReport < ApplicationRecord
  include AASM
  include SimpleAudit::Model
  simple_audit child: true

  enum credco_request_control: { auto_pull: 1, manual_pull: 2 }

  belongs_to :lessee
  has_one :recommended_credit_tier
  has_many :credit_report_bankruptcies
  has_many :credit_report_repossessions

  scope :unsuccessful, -> { where.not(status: 'success') }

  mount_uploader :upload, S3Uploader

  aasm :status do
    state :pending, initial: true
    state :success, :failure

    event :succeeded do
      transitions from: [:pending, :success, :failure], to: :success
    end

    event :failed do
      transitions from: [:pending, :failure, :success], to: :failure
    end
  end

  def record_errors_v1
    record_errors.select { |item| item.is_a? String }
  end

  def record_errors_v2
    record_errors.select { |item| item.is_a? Hash }
  end
end

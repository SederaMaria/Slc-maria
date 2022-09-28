# == Schema Information
#
# Table name: funding_delays
#
#  id                      :bigint(8)        not null, primary key
#  lease_application_id    :bigint(8)
#  funding_delay_reason_id :bigint(8)
#  notes                   :text
#  status                  :string           default("Required")
#  created_at              :datetime         not null
#  updated_at              :datetime         not null
#
# Indexes
#
#  funding_delay_reason_idx     (funding_delay_reason_id)
#  funding_delays_unique_index  (lease_application_id,funding_delay_reason_id)
#  lease_application_id_idx     (lease_application_id)
#
# Foreign Keys
#
#  fk_rails_...  (funding_delay_reason_id => funding_delay_reasons.id)
#  fk_rails_...  (lease_application_id => lease_applications.id)
#

class FundingDelay < ApplicationRecord
  include SimpleAudit::Model
  simple_audit child: true
  # overrides specificaly for Stipulations
  # include SimpleAudit::Custom::LeaseApplicationStipulation

  VALID_STATUSES = ['Required'.freeze, 'Not Required'.freeze, 'Cleared'.freeze].freeze

  belongs_to :lease_application
  belongs_to :funding_delay_reason

  validates :status, presence: true, inclusion: { in: VALID_STATUSES }
  validates :funding_delay_reason_id, :lease_application_id, presence: true
  validates :funding_delay_reason_id, uniqueness: { scope: :lease_application_id }, unless: :is_multiple_miscellaneous

  scope :required, -> { where(status: 'Required') }
  scope :not_not_required, -> { where.not(status: 'Not Required')}
  after_update :send_dealer_notification, if: :saved_change_to_status?

  def send_dealer_notification
    la = self.lease_application
    if la.funding_delays.pluck(:status).include?("Required")
      RemainingFundingDelayJob.perform_in(30.seconds, id: self.id)
    end
  end

  def is_multiple_miscellaneous
    self.funding_delay_reason_id == 56
  end
end

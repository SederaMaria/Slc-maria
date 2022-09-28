# == Schema Information
#
# Table name: funding_delay_reasons
#
#  id         :bigint(8)        not null, primary key
#  reason     :string
#  created_at :datetime         not null
#  updated_at :datetime         not null
#  active     :boolean          default(TRUE)
#

class FundingDelayReason < ApplicationRecord
  validates :reason, presence: true
end

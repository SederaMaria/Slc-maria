# == Schema Information
#
# Table name: stipulations
#
#  id                            :integer          not null, primary key
#  description                   :string
#  abbreviation                  :string
#  created_at                    :datetime         not null
#  updated_at                    :datetime         not null
#  required                      :boolean          default(FALSE)
#  position                      :integer
#  separator                     :string           default("-")
#  pre_income_stipulation        :boolean          default(FALSE)
#  post_income_stipulation       :boolean          default(FALSE)
#  post_submission_stipulation   :boolean          default(FALSE)
#  blocks_credit_status_approved :boolean          default(FALSE), not null
#  verification_call_problem     :boolean          default(FALSE)
#

class StipulationSerializer < ApplicationSerializer
  attributes :id, :description
end

# == Schema Information
#
# Table name: lease_application_blackbox_requests
#
#  id                               :bigint(8)        not null, primary key
#  lease_application_id             :integer
#  leadrouter_response              :string
#  leadrouter_credit_score          :float
#  leadrouter_suggested_corrections :string
#  created_at                       :datetime         not null
#  updated_at                       :datetime         not null
#  leadrouter_lead_id_int           :integer
#  leadrouter_request_body          :string
#  lessee_id                        :bigint(8)
#  leadrouter_lead_id               :uuid
#  blackbox_endpoint                :string
#  reject_stage                     :integer
#
# Indexes
#
#  index_lease_application_blackbox_requests_on_lessee_id  (lessee_id)
#
# Foreign Keys
#
#  fk_rails_...  (lessee_id => lessees.id)
#

class LeaseApplicationBlackboxRequest < ApplicationRecord
  enum request_control: { auto_pull: 1, manual_pull: 2 }
  serialize :leadrouter_request_body, JSON
  serialize :leadrouter_response, JSON
  serialize :leadrouter_suggested_corrections, Array
  belongs_to :lease_application
  belongs_to :lessee
  has_one :lessee_recommended_blackbox_tier
  has_one :recommended_credit_tier
  # has_one :lease_application
  has_many :lease_application_blackbox_adverse_reasons
  has_many :lease_application_blackbox_tlo_person_search_addresses
  has_many :lease_application_blackbox_errors
  has_many :lease_application_blackbox_employment_searches

  def self.convert_to_array history_object
    if history_object.class.to_s == "Hash"
      history_object = [history_object]
    end
    history_object
  end
end

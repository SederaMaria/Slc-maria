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

FactoryBot.define do
  factory :lease_application_blackbox_requests do
    leadrouter_response { "MyString" }
  end
end

# == Schema Information
#
# Table name: funding_request_histories
#
#  id                   :bigint(8)        not null, primary key
#  lease_application_id :bigint(8)
#  amount_cents         :integer
#  created_at           :datetime         not null
#  updated_at           :datetime         not null
#
# Indexes
#
#  index_funding_request_histories_on_lease_application_id  (lease_application_id)
#
# Foreign Keys
#
#  fk_rails_...  (lease_application_id => lease_applications.id)
#

FactoryBot.define do
  factory :funding_request_history do
    
  end
end

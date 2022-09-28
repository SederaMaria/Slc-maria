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

require 'rails_helper'

RSpec.describe FundingRequestHistory, type: :model do
  pending "add some examples to (or delete) #{__FILE__}"
end

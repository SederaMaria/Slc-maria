# == Schema Information
#
# Table name: lease_application_datax_requests
#
#  id                      :bigint(8)        not null, primary key
#  lease_application_id    :integer
#  leadrouter_request_body :string
#  leadrouter_response     :string
#  created_at              :datetime         not null
#  updated_at              :datetime         not null
#

class LeaseApplicationDataxRequest < ApplicationRecord
  serialize :leadrouter_request_body, JSON
  serialize :leadrouter_response, JSON
  belongs_to :lease_application
end

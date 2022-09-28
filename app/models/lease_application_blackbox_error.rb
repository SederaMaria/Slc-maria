# == Schema Information
#
# Table name: lease_application_blackbox_errors
#
#  id                                    :bigint(8)        not null, primary key
#  lease_application_blackbox_request_id :bigint(8)
#  error_code                            :integer
#  name                                  :string
#  message                               :string
#  failure_conditional                   :jsonb
#  created_at                            :datetime         not null
#  updated_at                            :datetime         not null
#
# Indexes
#
#  index_blackbox_errors_on_blackbox_request_id  (lease_application_blackbox_request_id)
#
# Foreign Keys
#
#  fk_rails_...  (lease_application_blackbox_request_id => lease_application_blackbox_requests.id)
#
class LeaseApplicationBlackboxError < ApplicationRecord
  belongs_to :lease_application_blackbox_request

  # @data [Hash] Data from Blackbox response "errorDetails"
  def self.create_data(data)
    if data && data.is_a?(Hash)
      self.create(
        error_code: data['code'],
        name: data['name'],
        message: data['message'],
        failure_conditional: data['failureConditional']
      )
    end
  end
end

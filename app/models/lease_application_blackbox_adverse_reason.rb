# == Schema Information
#
# Table name: lease_application_blackbox_adverse_reasons
#
#  id                                    :bigint(8)        not null, primary key
#  lease_application_blackbox_request_id :bigint(8)
#  reason_code                           :string
#  description                           :string
#  suggested_correction                  :string
#  created_at                            :datetime         not null
#  updated_at                            :datetime         not null
#
# Indexes
#
#  index_adverse_reasons_on_lease_app_blackbox_req  (lease_application_blackbox_request_id)
#
class LeaseApplicationBlackboxAdverseReason < ApplicationRecord
  belongs_to :lease_application_blackbox_request

  # OPTIONAL: Place this somewhere better, if possible
  #
  # @codes [Array<Hash>] Data from Blackbox response "adverseReasonCodes"
  def self.create_codes(codes)
    if codes && codes.respond_to?(:each)
      codes.each do |data|
        self.create(
          reason_code: data['code'],
          description: data['description'],
          suggested_correction: data['suggestedCorrection']
        )
      end
    end
  end
end

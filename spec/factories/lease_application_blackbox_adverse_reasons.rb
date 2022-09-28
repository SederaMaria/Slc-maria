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
FactoryBot.define do
  factory :lease_application_blackbox_adverse_reason do

  end
end

# == Schema Information
#
# Table name: lease_application_funding_delays
#
#  id                      :bigint(8)        not null, primary key
#  lease_application_id    :bigint(8)
#  funding_delay_reason_id :bigint(8)
#  description             :text
#  applied_on              :date
#  status                  :integer
#  created_at              :datetime         not null
#  updated_at              :datetime         not null
#
# Indexes
#
#  funding_delay_reason_idx                       (funding_delay_reason_id)
#  lease_application_funding_delays_unique_index  (lease_application_id,funding_delay_reason_id) UNIQUE
#  lease_application_id_idx                       (lease_application_id)
#
# Foreign Keys
#
#  fk_rails_...  (funding_delay_reason_id => funding_delay_reasons.id)
#  fk_rails_...  (lease_application_id => lease_applications.id)
#

FactoryBot.define do
  factory :lease_application_funding_delay do
    lease_application { nil }
    funding_delay { nil }
    description { "MyText" }
    applied_on { "2018-03-05" }
    status { 1 }
  end
end

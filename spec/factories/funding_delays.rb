# == Schema Information
#
# Table name: funding_delays
#
#  id                      :bigint(8)        not null, primary key
#  lease_application_id    :bigint(8)
#  funding_delay_reason_id :bigint(8)
#  notes                   :text
#  status                  :string           default("Required")
#  created_at              :datetime         not null
#  updated_at              :datetime         not null
#
# Indexes
#
#  funding_delay_reason_idx     (funding_delay_reason_id)
#  funding_delays_unique_index  (lease_application_id,funding_delay_reason_id)
#  lease_application_id_idx     (lease_application_id)
#
# Foreign Keys
#
#  fk_rails_...  (funding_delay_reason_id => funding_delay_reasons.id)
#  fk_rails_...  (lease_application_id => lease_applications.id)
#

FactoryBot.define do
  factory :funding_delay do
    lease_application
    funding_delay_reason
    #status 'Required' #this is the default value
    notes { FFaker::BaconIpsum.sentence }
  end
end

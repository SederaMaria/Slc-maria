# == Schema Information
#
# Table name: lease_application_stipulations
#
#  id                              :integer          not null, primary key
#  lease_application_id            :integer          not null
#  stipulation_id                  :integer          not null
#  status                          :string           default("Required"), not null
#  created_at                      :datetime         not null
#  updated_at                      :datetime         not null
#  lease_application_attachment_id :integer
#  notes                           :text
#  monthly_payment_limit_cents     :integer          default(0), not null
#
# Indexes
#
#  index_lease_application_stipulations_on_lease_application_id  (lease_application_id)
#  index_lease_application_stipulations_on_stipulation_id        (stipulation_id)
#  index_lease_application_stipulations_uniqueness               (lease_application_id,stipulation_id) UNIQUE
#  lease_application_stipulations_attachment                     (lease_application_attachment_id)
#
# Foreign Keys
#
#  fk_rails_...  (lease_application_id => lease_applications.id)
#  fk_rails_...  (stipulation_id => stipulations.id)
#

FactoryBot.define do
  factory :lease_application_stipulation do
    lease_application
    lease_application_attachment
    stipulation
    status { LeaseApplicationStipulation::VALID_STATUSES.sample }
    notes { FFaker::BaconIpsum.paragraph }

  end
end

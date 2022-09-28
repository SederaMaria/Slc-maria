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

class LeaseApplicationStipulation < ApplicationRecord
  include SimpleAudit::Model
  simple_audit child: true
  # overrides specificaly for Stipulations
  include SimpleAudit::Custom::LeaseApplicationStipulation
  
  VALID_STATUSES = ['Required', 'Not Required', 'Cleared'].freeze

  belongs_to :lease_application_attachment
  belongs_to :lease_application
  belongs_to :stipulation

  validates :status, presence: true, inclusion: { in: VALID_STATUSES }
  validates :stipulation_id, :lease_application_id, presence: true
  validates :stipulation, uniqueness: { scope: :lease_application }

  scope :required, -> { where(status: 'Required') }

  #monetize all _cents fields with a couple of lines
  if table_exists? #fix issue with rake db:schema:load
    self.column_names.each { |col| monetize(col) if col.ends_with?('_cents') }
  end
  
end

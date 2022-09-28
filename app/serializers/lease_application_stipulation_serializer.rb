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

class LeaseApplicationStipulationSerializer < ApplicationSerializer
  attributes :id, :lease_application_id, :stipulation, :status, 
             :lease_application_attachment_id, :notes, :application_identifier, :attachment


  def stipulation
    object&.stipulation&.description
  end
  
  def application_identifier
    object&.lease_application&.application_identifier
  end

  def attachment
    object&.lease_application_attachment&.read_attribute(:upload)
  end

end

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

require 'rails_helper'

RSpec.describe LeaseApplicationStipulation, type: :model do

  describe '#simple_audit' do
    it { is_expected.to be_simple_audited }
    let!(:lease_application_stipulation) { create(:lease_application_stipulation, status: 'Required') }
    let(:stipulation) { lease_application_stipulation.stipulation }
    let(:attachment) { lease_application_stipulation.lease_application_attachment }
    let(:audit) { lease_application_stipulation.audits.last }

    context '#create' do
      it 'creates audits on create' do
        changes = "#{bold('Created')} this Lease Application Stipulation with #{bold('Stipulation')} set to #{bold(stipulation.description)}, " \
                  "#{bold('Lease Application Attachment')} set to #{bold(attachment.read_attribute('upload'))}, " \
                  "and #{bold('Notes')} set to #{bold(lease_application_stipulation.notes)}"
        expect(audit.audited_changes).to eql(changes)
      end
    end
  end

  describe 'validations' do
    let!(:lease_application_stipulation) { create(:lease_application_stipulation) }
    let(:lease_application) { lease_application_stipulation.lease_application }
    let(:stipulation) { lease_application_stipulation.stipulation }
    let(:new_lease_application_stipulation) do
      LeaseApplicationStipulation.new(lease_application_id: lease_application.id, stipulation_id: stipulation.id)
    end

    it 'should not violate uniqueness of lease application and stipulation' do
      expect(new_lease_application_stipulation.valid?).to be_falsey
    end
  end
end

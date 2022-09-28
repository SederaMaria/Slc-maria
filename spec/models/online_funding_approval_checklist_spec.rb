# == Schema Information
#
# Table name: online_funding_approval_checklists
#
#  id                              :bigint(8)        not null, primary key
#  no_markups_or_erasure           :boolean          default(FALSE)
#  lease_agreement_signed          :boolean          default(FALSE)
#  motorcycle_condition_reported   :boolean          default(FALSE)
#  credit_application_signed       :boolean          default(FALSE)
#  four_references_present         :boolean          default(FALSE)
#  valid_dl                        :boolean          default(FALSE)
#  ach_form_completed              :boolean          default(FALSE)
#  insurance_requirements          :boolean          default(FALSE)
#  valid_email_address             :boolean          default(FALSE)
#  registration_documents_with_slc :boolean          default(FALSE)
#  ods_signed_and_dated            :boolean          default(FALSE)
#  proof_of_amounts_due            :boolean          default(FALSE)
#  documentation_to_satisfy        :boolean          default(FALSE)
#  warranty_products_purchased     :boolean          default(FALSE)
#  signed_bos                      :boolean          default(FALSE)
#  package_reviewed                :boolean          default(FALSE)
#  package_reviewed_on             :datetime
#  reviewed_by                     :integer
#  lease_application_id            :bigint(8)
#  created_at                      :datetime         not null
#  updated_at                      :datetime         not null
#  pdf_url                         :string
#
# Indexes
#
#  index_lease_applications_on_funding_approval_checklist_id  (lease_application_id)
#
# Foreign Keys
#
#  fk_rails_...  (lease_application_id => lease_applications.id)
#

require 'rails_helper'
=begin
RSpec.describe OnlineFundingApprovalChecklist, type: :model do

  checklist = OnlineFundingApprovalChecklist.new(
    no_markups_or_erasure: false,
    lease_agreement_signed: true,
    motorcycle_condition_reported: false,
    credit_application_signed: false,
    four_references_present: false,
    valid_dl: true,
    ach_form_completed: false,
    insurance_requirements: false,
    valid_email_address: false,
    registration_documents_with_slc: false,
    ods_signed_and_dated: false,
    proof_of_amounts_due: true,
    documentation_to_satisfy: false,
    warranty_products_purchased: false,
    signed_bos: true,
    package_reviewed: false,
    package_reviewed_on: DateTime.current.to_date,
    reviewed_by: 129,
    lease_application_id: 39586,
  )
  it 'return description' do
      expect(checklist.no_markups_or_erasure).to eq false
      expect(checklist.lease_agreement_signed).to eq true
      expect(checklist.motorcycle_condition_reported).to eq false
      expect(checklist.credit_application_signed).to eq false
      expect(checklist.four_references_present).to eq false
      expect(checklist.valid_dl).to eq true
      expect(checklist.ach_form_completed).to eq false
      expect(checklist.insurance_requirements).to eq false
      expect(checklist.valid_email_address).to eq false
      expect(checklist.registration_documents_with_slc).to eq false
      expect(checklist.ods_signed_and_dated).to eq false
      expect(checklist.proof_of_amounts_due).to eq true
      expect(checklist.documentation_to_satisfy).to eq false
      expect(checklist.warranty_products_purchased).to eq false
      expect(checklist.signed_bos).to eq true
      expect(checklist.package_reviewed).to eq false
      expect(checklist.reviewed_by).to eq 129
      expect(checklist.lease_application_id).to eq 39586
  end


  it 'should Lease Application belongs to' do
    t = OnlineFundingApprovalChecklist.reflect_on_association(:lease_application)
    expect(t.macro).to eq(:belongs_to)
  end

  it 'should Lease Application belongs to' do
    t = OnlineFundingApprovalChecklist.reflect_on_association(:admin_user)
    expect(t.macro).to eq(:belongs_to)
  end

end
=end
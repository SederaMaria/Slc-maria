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

FactoryBot.define do
  factory :online_funding_approval_checklist do
    
  end
end

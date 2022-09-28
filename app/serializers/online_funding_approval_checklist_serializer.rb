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

class OnlineFundingApprovalChecklistSerializer < ApplicationSerializer
  attributes :id, :no_markups_or_erasure, :lease_agreement_signed, :motorcycle_condition_reported, 
            :credit_application_signed, :four_references_present, :valid_dl, :ach_form_completed, 
            :insurance_requirements, :valid_email_address, :registration_documents_with_slc, :ods_signed_and_dated, 
            :proof_of_amounts_due, :documentation_to_satisfy, :warranty_products_purchased, :signed_bos, 
            :package_reviewed, :package_reviewed_on, :reviewed_by


  def reviewed_by
    object&.reviewer&.full_name
  end

  def package_reviewed_on
    object&.package_reviewed_on&.strftime("%B %d, %Y")
  end

end

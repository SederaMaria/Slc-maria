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

require 'fileutils'

class OnlineFundingApprovalChecklist < ApplicationRecord
  include SimpleAudit::Model
  simple_audit child: true

  belongs_to :lease_application
  belongs_to :reviewer, foreign_key: 'reviewed_by', class_name: 'AdminUser'

  FORM_PATH = "#{Rails.root}/app/assets/data/online_funding_approval_checklist/online_funding_approval_checklist.pdf"

  def prefilled
    return prefilled_doc_path
  end

  def prefilled_for_download
    return prefilled_download_path
  end

  private

  def pdftk
    @pdftk ||= PdfForms.new(pdftk_path)
  end

  def pdftk_path
    PdftkConfig.executable_path
  end
  
  def prefilled_download_path
    directory = File.join(Rails.root, 'public','online_funding_approval_checklist', "#{lease_application.online_funding_approval_checklist.id}")
    if Dir.exist?(directory)
      FileUtils.rm_rf(directory)     
    end
    ext_time = DateTime.now.to_i
    FileUtils::mkdir_p(File.join(Rails.root, 'public','online_funding_approval_checklist', "#{lease_application.online_funding_approval_checklist.id}"))
    dest_doc_path   = File.join(Rails.root, 'public', 'online_funding_approval_checklist', "#{lease_application.online_funding_approval_checklist.id}", "online-funding-approval-checklist-#{lease_application.online_funding_approval_checklist.id}-#{ext_time}.pdf")
    pdftk.fill_form FORM_PATH, dest_doc_path, fields, flatten: true
    return "#{ENV['ADMIN_PORTAL_BASE_URL']}/online_funding_approval_checklist/#{lease_application.online_funding_approval_checklist.id}/online-funding-approval-checklist-#{lease_application.online_funding_approval_checklist.id}-#{ext_time}.pdf"
  end

  def prefilled_doc_path
    FileUtils::mkdir_p(File.join(Rails.root, 'tmp', 'online_funding_approval_checklist'))
    dest_doc_path   = File.join(Rails.root, 'tmp', 'online_funding_approval_checklist', "online-funding-approval-checklist-#{lease_application.online_funding_approval_checklist.id}.pdf")
    pdftk.fill_form FORM_PATH, dest_doc_path, fields, flatten: true
    return dest_doc_path
  end

  def fields
    {
      "no_markups_or_erasure"           => checkbox(self&.no_markups_or_erasure),
      "lease_agreement_signed"          => checkbox(self&.lease_agreement_signed),
      "motorcycle_condition_reported"   => checkbox(self&.motorcycle_condition_reported),
      "credit_application_signed"       => checkbox(self&.credit_application_signed),
      "four_references_present"         => checkbox(self&.four_references_present),
      "valid_dl"                        => checkbox(self&.valid_dl),
      "ach_form_completed"              => checkbox(self&.ach_form_completed),
      "insurance_requirements"          => checkbox(self&.insurance_requirements),
      "valid_email_address"             => checkbox(self&.valid_email_address),
      "registration_documents_with_slc" => checkbox(self&.registration_documents_with_slc),
      "ods_signed_and_dated"            => checkbox(self&.ods_signed_and_dated),
      "proof_of_amounts_due"            => checkbox(self&.proof_of_amounts_due),
      "documentation_to_satisfy"        => checkbox(self&.documentation_to_satisfy),
      "warranty_products_purchased"     => checkbox(self&.warranty_products_purchased),
      "signed_bos"                      => checkbox(self&.signed_bos),
      "lessee"                          => self&.lease_application&.lessee&.full_name,
      "dealer"                          => self&.lease_application&.dealership&.name,
      "document_requested"              => document_requested_field,
      "document_recieved_date"          => document_recieved_date_field,
      "lease_number"                    => self&.lease_application&.application_identifier,
      "funding_approved"                => checkbox(funding_approved),
      "package_reviewed"                => checkbox(self&.package_reviewed),
      "package_reviewed_on"             => package_reviewed_on_field,
      "package_reviewed_by"             => package_reviewed_by_field,
      "approved_on"                     => approved_on_field,
      "approved_by"                     => approved_by_field
    }
  end

  def checkbox(col)
    return 'Yes' if col
    'Off'
  end

  def document_requested_field
    self&.lease_application&.last_lease_document_request&.created_at.nil? ? 'Documents not yet requested' : self&.lease_application&.last_lease_document_request&.created_at&.strftime("%B %d, %Y")
  end

  def document_recieved_date_field
    self&.lease_application&.lease_package_received_date.nil? ? 'Documents not yet received' : self&.lease_application&.lease_package_received_date&.strftime("%B %d, %Y")
  end

  def funding_approved
    ['funding_approved', 'funded'].include?(self&.lease_application&.document_status)
  end

  def approved_on_field
    return nil if !funding_approved
    self&.lease_application&.funding_approved_on&.strftime("%B %d, %Y")
  end
  
  def approved_by_field
    return nil if !funding_approved
    self&.lease_application&.approver&.full_name
  end

  def approved_by_field
    return '' if !funding_approved
    self&.reviewer&.full_name
  end

  def package_reviewed_on_field
    return nil if !self&.package_reviewed
    self&.package_reviewed_on&.strftime("%B %d, %Y")
  end

  def package_reviewed_by_field
    return nil if !self&.package_reviewed
    self&.reviewer&.full_name
  end

end

# == Schema Information
#
# Table name: lease_application_attachments
#
#  id                      :integer          not null, primary key
#  lease_application_id    :integer
#  notes                   :text
#  created_at              :datetime         not null
#  updated_at              :datetime         not null
#  visible_to_dealers      :boolean          default(TRUE), not null
#  description             :string
#  lessee_id               :integer
#  merge_report_identifier :string
#  upload                  :string
#  uploader_type           :string
#  uploader_id             :bigint(8)
#
# Indexes
#
#  index_lease_application_attachments_on_lease_application_id  (lease_application_id)
#  index_lease_application_attachments_on_lessee_id             (lessee_id)
#  lease_app_uploader_idx                                       (uploader_id,uploader_type)
#
# Foreign Keys
#
#  fk_rails_...  (lease_application_id => lease_applications.id)
#

class LeaseApplicationAttachment < ApplicationRecord
  include SimpleAudit::Model
  simple_audit child: true
  include SimpleAudit::Custom::LeaseApplicationAttachment
  
  belongs_to :lease_application
  belongs_to :lessee, optional: true
  belongs_to :uploader, polymorphic: true, optional: true
  has_many :lease_application_stipulation
  has_many :lease_application_attachment_meta_data
  has_many :income_verification_attachments

  mount_uploader :upload, S3Uploader

  validates :upload, presence: true, on: :create

  scope :visible_to_dealers_only, -> { where(visible_to_dealers: true) }

  def self.merge_reports
    where.not(merge_report_identifier: nil)
  end


  def file_attachment_type_ids
    lease_application_attachment_meta_data&.all&.pluck(:file_attachment_type_id)
  end

  def income_verification_attachment_ids
    income_verification_attachments&.all&.pluck(:income_verification_id)
  end


  def is_income_verification_selected
    file_attachment_type_ids.include?(FileAttachmentType.income_verification.id)
  end


end

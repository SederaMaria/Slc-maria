class LeaseApplicationAttachmentSerializer < ApplicationSerializer
  include Rails.application.routes.url_helpers
  attributes :id, :created_at, :description, :filename, :uploader, :download_send_dealership_link, 
              :is_visible_to_dealership, :file_attachment_type_ids, :income_verification_attachment_ids,
              :is_income_verification_selected, :income_verification_file_type_id


  def filename
    object.upload.file&.filename
  end
  
  def uploader
    object&.uploader&.decorate&.display_name || 'Unknown / System'
  end

  def is_visible_to_dealership
    unless object.description == 'Funding Request Form'
      object.visible_to_dealers?
    end
  end
    
  def download_send_dealership_link
    { download_url: object.upload.url, send_to_dealer_url:  mail_attachment_to_dealership_path(object) }
  end

  def created_at
    object&.created_at.strftime('%B %-d %Y at %r %Z')
  end

  def file_attachment_type_ids
    object&.file_attachment_type_ids
  end

  def income_verification_attachment_ids
    object&.income_verification_attachment_ids
  end

  def is_income_verification_selected
    object&.is_income_verification_selected
  end

  def income_verification_file_type_id
    FileAttachmentType.income_verification.id
  end


end
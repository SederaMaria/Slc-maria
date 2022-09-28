class LeaseApplicationAttachmentMetaDatum < ApplicationRecord
    belongs_to :lease_application
    belongs_to :lease_application_attachment
    belongs_to :file_attachment_type
end

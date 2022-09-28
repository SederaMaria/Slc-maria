class DealershipAttachmentSerializer < ApplicationSerializer
    attributes :id, :description, :filename, :uploaded_by, :created_at, :url 

    def description
        object&.upload&.identifier
    end

    def filename
        object&.upload&.identifier
    end

    def uploaded_by
        object&.admin_user&.full_name
    end

    def url
        object&.upload&.url
    end


end
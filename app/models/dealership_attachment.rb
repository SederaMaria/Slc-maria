class DealershipAttachment < ApplicationRecord
    belongs_to :admin_user
    belongs_to :dealership
    mount_uploader :upload, S3Uploader
end

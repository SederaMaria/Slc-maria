class FileAttachmentType < ApplicationRecord

    scope :income_verification,     -> { find_by(label: "Income Verification") }

end

class IncomeVerificationAttachment < ApplicationRecord
    include SimpleAudit::Model
    simple_audit child: true
    include SimpleAudit::Custom::IncomeVerification

    belongs_to :income_verification
    belongs_to :lease_application_attachment

end

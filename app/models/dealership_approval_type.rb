class DealershipApprovalType < ApplicationRecord
    scope :sales,                           -> { find_by(description: "Sales") }
    scope :underwriting,                    -> { find_by(description: "Underwriting") }
    scope :dealership_credit_committee,     -> { find_by(description: "Credit Committee") }
end

class DealershipApprovalEvent < ApplicationRecord
    belongs_to :admin_user
    belongs_to :dealership_approval
end

class DealershipApproval < ApplicationRecord
    belongs_to :dealership_approval_type
    has_many :dealership_approval_events


    def events_by_admin_users
        dealership_approval_events.where(id: dealership_approval_events.group(:admin_user_id).maximum(:id).values)
    end

end

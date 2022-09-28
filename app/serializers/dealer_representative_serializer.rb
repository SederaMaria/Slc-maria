class DealerRepresentativeSerializer < ApplicationSerializer
    attributes :id, :email, :dealership_id, :first_name, :last_name, :admin_user_id, :is_active, :full_name, :option_value, :option_label, :full_name

    def full_name
        object&.full_name
    end

    def option_value
        object&.id
    end

    def option_label
        object&.full_name
    end

end

class WorkflowSettingValueSerializer < ApplicationSerializer
    attributes :id, :admin_user, :workflow_setting_id

    def admin_user
        {   
            id: object&.admin_user&.id,
            optionLabel: object&.admin_user&.full_name,
            optionValue: object&.admin_user&.id,
        }
    end
    
end
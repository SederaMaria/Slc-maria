class WorkflowSettingValue < ApplicationRecord
    belongs_to :workflow_setting
    belongs_to :admin_user
end

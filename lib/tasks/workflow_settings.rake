namespace :workflow_settings do

  desc 'Change Operations Approvers to Underwriting Approvers'
  task change_ops_to_underwriting: :environment do
    WorkflowSetting.where(workflow_setting_name: 'Operations Approvers').update_all(workflow_setting_name: 'Underwriting Approvers')
    WorkflowSetting.where(workflow_setting_name: 'Notify Operations Approvers').update_all(workflow_setting_name: 'Notify Underwriting Approvers')
    WorkflowSetting.where(workflow_setting_name: 'Not Notify Operations Approvers').update_all(workflow_setting_name: 'Not Notify Underwriting Approvers')
  end

  desc 'Change Final Approvers to Credit Committee Approvers'
  task change_final_to_credit_committee: :environment do
    WorkflowSetting.where(workflow_setting_name: 'Final Approvers').update_all(workflow_setting_name: 'Credit Committee Approvers')
    WorkflowSetting.where(workflow_setting_name: 'Notify Final Approvers').update_all(workflow_setting_name: 'Notify Credit Committee Approvers')
    WorkflowSetting.where(workflow_setting_name: 'Not Notify Final Approvers').update_all(workflow_setting_name: 'Not Notify Credit Committee Approvers')
  end  

end
  
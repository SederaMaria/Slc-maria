class WorkflowSetting < ApplicationRecord
    belongs_to :workflow
    validates :workflow_setting_name, presence: true, uniqueness: true

    scope :sales,     -> { find_by(workflow_setting_name: "Sales Approvers") }
    scope :dealership_underwriting,     -> { find_by(workflow_setting_name: "Underwriting Approvers") }
    scope :notify_dealership_underwriting,     -> { find_by(workflow_setting_name: "Notify Underwriting Approvers") }
    scope :not_notify_dealership_underwriting,     -> { find_by(workflow_setting_name: "Not Notify Underwriting Approvers") }
    scope :dealership_credit_committee,     -> { find_by(workflow_setting_name: "Credit Committee Approvers") }
    scope :notify_dealership_credit_committee,     -> { find_by(workflow_setting_name: "Notify Credit Committee Approvers") }
    scope :not_notify_dealership_credit_committee,     -> { find_by(workflow_setting_name: "Not Notify Credit Committee Approvers") }
    scope :underwriting,     -> { find_by(workflow_setting_name: "Underwriting Reviewers") }
    scope :notify_underwriting,     -> { find_by(workflow_setting_name: "Notify Requested Review") }
    scope :not_notify_underwriting,     -> { find_by(workflow_setting_name: "Not Notify Requested Review") }

end

# == Schema Information
#
# Table name: workflow_statuses
#
#  id          :bigint(8)        not null, primary key
#  description :string
#  active      :boolean
#  created_at  :datetime         not null
#  updated_at  :datetime         not null
#

class WorkflowStatus < ApplicationRecord

    scope :application,     -> { find_by(description: "Application") }
    scope :underwriting,     -> { find_by(description: "Underwriting") }
    scope :underwriting_review,     -> { find_by(description: "Underwriting Review") }
    scope :verification,     -> { find_by(description: "Verification") }
    scope :funding,     -> { find_by(description: "Funding") }
    scope :done,     -> { find_by(description: "Done") }
    scope :underwriting_approved,     -> { find_by(description: "Underwriting Approved") }

end

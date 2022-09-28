class AddWorkflowToApplication < ActiveRecord::Migration[5.1]
  def change
    add_reference :lease_applications, :workflow_status, foreign_key: true
  end
end

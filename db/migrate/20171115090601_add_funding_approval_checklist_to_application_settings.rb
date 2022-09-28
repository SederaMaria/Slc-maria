class AddFundingApprovalChecklistToApplicationSettings < ActiveRecord::Migration[5.1]
  def change
    add_column :application_settings, :funding_approval_checklist, :string
  end
end

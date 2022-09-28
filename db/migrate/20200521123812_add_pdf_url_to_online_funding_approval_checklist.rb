class AddPdfUrlToOnlineFundingApprovalChecklist < ActiveRecord::Migration[5.1]
  def change
    add_column :online_funding_approval_checklists, :pdf_url, :string
  end
end

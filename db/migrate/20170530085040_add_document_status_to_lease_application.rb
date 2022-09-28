class AddDocumentStatusToLeaseApplication < ActiveRecord::Migration[5.0]
  def change
    add_column :lease_applications, :document_status, :string
  end
end

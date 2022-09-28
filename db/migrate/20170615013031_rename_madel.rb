class RenameMadel < ActiveRecord::Migration[5.0]
  def change
    rename_column :lease_document_requests, :asset_madel, :asset_model
  end
end

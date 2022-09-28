class AddManualVinVerificationToLeaseDocumentRequest < ActiveRecord::Migration[5.1]
  def change
    add_column :lease_document_requests, :manual_vin_verification, :boolean, defaut: false
  end
end

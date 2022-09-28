class AddModelYearToLeaseDocumentRequests < ActiveRecord::Migration[6.0]
  def change
    add_reference :lease_document_requests, :model_year, foreign_key: true, index: true
  end
end

class AddDocumentsRequestedDateToLeaseApplications < ActiveRecord::Migration[6.0]
  def change
    add_column :lease_applications, :documents_requested_date, :date
  end
end

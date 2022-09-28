class AddDocumentsIssuedDateToLeaseApplication < ActiveRecord::Migration[5.0]
  def change
    add_column :lease_applications, :documents_issued_date, :date
  end
end

class AddDefaultValueToLeaseApplication < ActiveRecord::Migration[5.0]

  def up
    LeaseApplication.where(credit_status: nil).update_all(credit_status: 'unsubmitted')
    LeaseApplication.where(document_status: nil).update_all(document_status: 'no_documents')
    change_column_default :lease_applications, :document_status, 'no_documents'
    change_column_default :lease_applications, :credit_status, 'unsubmitted'
    change_column_null :lease_applications, :document_status, false
    change_column_null :lease_applications, :credit_status, false
  end

  def down
    change_column_default :lease_applications, :document_status, nil
    change_column_default :lease_applications, :credit_status, nil
    change_column_null :lease_applications, :document_status, true
    change_column_null :lease_applications, :credit_status, true
  end
end

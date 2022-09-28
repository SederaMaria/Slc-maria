class RemoveLeaseApplicationIdFromInsuranceCompanies < ActiveRecord::Migration[5.1]
  def change
    remove_column :insurance_companies, :lease_application_id, :bigint
  end
end

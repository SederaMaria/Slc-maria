class RenameInsuranceCompaniesIdInInsurance < ActiveRecord::Migration[5.1]
  def change
  	rename_column :insurances, :insurance_companies_id, :insurance_company_id
  end
end

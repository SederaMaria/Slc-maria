class AddInsuranceCompanyToInsurance < ActiveRecord::Migration[5.1]
  def change
    add_reference :insurances, :insurance_companies, foreign_key: true
  end
end

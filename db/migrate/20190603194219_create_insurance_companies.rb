class CreateInsuranceCompanies < ActiveRecord::Migration[5.1]
  def change
    create_table :insurance_companies do |t|
      t.string :company_name
      t.string :company_code
      t.references :lease_application, foreign_key: true

      t.timestamps
    end
  end
end

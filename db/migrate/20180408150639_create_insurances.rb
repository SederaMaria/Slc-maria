class CreateInsurances < ActiveRecord::Migration[5.1]
  def change
    create_table :insurances do |t|
      t.string :company_name
      t.string :bodily_injury_per_person
      t.string :bodily_injury_per_occurrence
      t.string :comprehensive
      t.string :collision
      t.string :property_damage
      t.date :effective_date
      t.date :expiration_date
      t.boolean :loss_payee
      t.boolean :additional_insured

      t.references :lease_application
      t.timestamps
    end
  end
end

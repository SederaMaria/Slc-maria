class CreateIncomeVerifications < ActiveRecord::Migration[6.0]
  def change
    create_table :income_verifications do |t|
      t.references :lessee
      t.references :income_verification_type

      t.string :employer_client
      t.integer :gross_income_cents

      t.references :income_frequency
      t.references :lease_application_attachment

      t.references :created_by_admin, foreign_key: { to_table: :admin_users }, index: { name: 'index_income_verifications_created_by_on_admin_user_id' }
      t.references :updated_by_admin, foreign_key: { to_table: :admin_users }, index: { name: 'index_income_verifications_updated_by_on_admin_user_id' }

      t.timestamps
    end
  end
end

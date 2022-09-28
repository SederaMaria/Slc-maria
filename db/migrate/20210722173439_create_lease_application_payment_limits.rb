class CreateLeaseApplicationPaymentLimits < ActiveRecord::Migration[6.0]
  def change
    create_table :lease_application_payment_limits do |t|
      t.references :lease_application, foreign_key: true, index: { name: 'index_payment_limits_on_lease_application_id' }
      t.references :credit_tier, foreign_key: true, index: { name: 'index_payment_limits_on_credit_tier_id' }
      t.integer :proven_monthly_income_cents
      t.integer :max_allowable_payment_cents
      t.integer :variance
      t.timestamps
    end
  end
end

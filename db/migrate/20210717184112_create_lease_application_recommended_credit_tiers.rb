class CreateLeaseApplicationRecommendedCreditTiers < ActiveRecord::Migration[6.0]
  def change
    create_table :lease_application_recommended_credit_tiers do |t|
      t.references :lease_application, foreign_key: true, index: { name: 'index_recommended_credit_tiers_on_lease_application_id' }
      t.references :credit_tier, foreign_key: true, index: { name: 'index_recommended_credit_tiers_on_credit_tier_id' }
      t.integer :lessee_credit_report_id
      t.integer :colessee_credit_report_id
      t.timestamps
    end
  end
end

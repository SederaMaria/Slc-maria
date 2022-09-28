class CreateRecommendedCreditTiers < ActiveRecord::Migration[5.1]
  def change
    create_table :recommended_credit_tiers do |t|
      t.integer :lessee_id
      t.integer :credit_tier_id
      t.integer :credit_report_id
      t.integer :recommended_credit_tier

      t.timestamps
    end
  end
end

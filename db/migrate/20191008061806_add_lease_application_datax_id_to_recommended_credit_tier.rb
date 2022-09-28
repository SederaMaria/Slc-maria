class AddLeaseApplicationDataxIdToRecommendedCreditTier < ActiveRecord::Migration[5.1]
  def change
    add_column :recommended_credit_tiers, :lease_application_datax_id, :integer
  end
end

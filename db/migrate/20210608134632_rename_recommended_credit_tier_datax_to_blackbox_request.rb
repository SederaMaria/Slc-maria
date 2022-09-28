class RenameRecommendedCreditTierDataxToBlackboxRequest < ActiveRecord::Migration[6.0]
  def change
    rename_column :recommended_credit_tiers, :lease_application_datax_id, :lease_application_blackbox_request_id
  end
end

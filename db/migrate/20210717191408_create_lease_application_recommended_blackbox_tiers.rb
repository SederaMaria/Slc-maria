class CreateLeaseApplicationRecommendedBlackboxTiers < ActiveRecord::Migration[6.0]
  def change
    create_table :lease_application_recommended_blackbox_tiers do |t|
      t.references :lease_application, foreign_key: true, index: { name: 'index_recommended_blackbox_tiers_on_lease_application_id' }
      t.references :blackbox_model_detail, foreign_key: true, index: { name: 'index_recommended_blackbox_tiers_on_blackbox_model_detail_id' }
      t.integer :lessee_lease_application_blackbox_request_id
      t.integer :colessee_lease_application_blackbox_request_id
      t.timestamps
    end
  end
end

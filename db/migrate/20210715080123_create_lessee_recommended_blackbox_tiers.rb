class CreateLesseeRecommendedBlackboxTiers < ActiveRecord::Migration[6.0]
  def change
    create_table :lessee_recommended_blackbox_tiers do |t|
      t.references :lessee, foreign_key: true, index: true
      t.references :blackbox_model_detail, foreign_key: true, index: { name: 'lrbt_on_blackbox_model_detail_id' }
      t.references :lease_application_blackbox_request, foreign_key: true, index: { name: 'lrbt_on_lease_application_blackbox_request_id' }
      t.timestamps
    end
  end
end

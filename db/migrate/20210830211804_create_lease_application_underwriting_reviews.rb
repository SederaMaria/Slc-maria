class CreateLeaseApplicationUnderwritingReviews < ActiveRecord::Migration[6.0]
  def change
    create_table :lease_application_underwriting_reviews do |t|
      t.references :lease_application, index: { name: 'index_la_underwriting_reviews_on_lease_application_id' }
      t.references :admin_user, index: { name: 'index_la_underwriting_reviews_on_admin_user_id' }
      t.references :workflow_status, index: { name: 'index_la_underwriting_reviews_on_workflow_status_id' }
      t.string :comments

      t.timestamps
    end
  end
end

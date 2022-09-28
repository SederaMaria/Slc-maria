class CreateLeaseApplicationBlackboxAdverseReasons < ActiveRecord::Migration[6.0]
  def change
    create_table :lease_application_blackbox_adverse_reasons do |t|
      t.references :lease_application_blackbox_request, index: { name: :index_adverse_reasons_on_lease_app_blackbox_req }
      t.string :reason_code
      t.string :description
      t.string :suggested_correction
      t.timestamps
    end
  end
end

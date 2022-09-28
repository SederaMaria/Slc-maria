class AddReactStageToBlackboxRequest < ActiveRecord::Migration[6.0]
  def change
    add_column :lease_application_blackbox_requests, :reject_stage, :integer
  end
end

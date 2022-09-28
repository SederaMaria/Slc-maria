class AddDealerVisibilityToLeaseApplicationAttachments < ActiveRecord::Migration[5.0]
  def change
    add_column :lease_application_attachments, :visible_to_dealers, :boolean, default: true, null: false
  end
end

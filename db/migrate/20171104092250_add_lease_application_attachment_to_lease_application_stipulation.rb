class AddLeaseApplicationAttachmentToLeaseApplicationStipulation < ActiveRecord::Migration[5.1]
  def change
    add_column :lease_application_stipulations, :lease_application_attachment_id, :integer
    add_index :lease_application_stipulations, :lease_application_attachment_id, name: :lease_application_stipulations_attachment
  end
end

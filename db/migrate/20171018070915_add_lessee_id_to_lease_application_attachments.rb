class AddLesseeIdToLeaseApplicationAttachments < ActiveRecord::Migration[5.0]
  def change
    add_column :lease_application_attachments, :lessee_id, :integer
  end
end

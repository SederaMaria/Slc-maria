class AddFullReportIdentifierToLeaseApplicationAttachments < ActiveRecord::Migration[5.0]
  def change
    add_column :lease_application_attachments, :merge_report_identifier, :string
  end
end

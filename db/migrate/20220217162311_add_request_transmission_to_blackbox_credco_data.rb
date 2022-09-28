class AddRequestTransmissionToBlackboxCredcoData < ActiveRecord::Migration[6.0]
  def change
    add_column :lease_application_blackbox_requests, :request_control, :integer, limit: 1
    add_column :lease_application_blackbox_requests, :request_event_source, :string
    add_column :credit_reports, :credco_request_control, :integer, limit: 1
    add_column :credit_reports, :credco_request_event_source, :string
  end
end

class AddLeadrouterRequestBodyToLeaseApplicationDatax < ActiveRecord::Migration[5.1]
  def change
    add_column :lease_application_dataxes, :leadrouter_request_body, :string
  end
end

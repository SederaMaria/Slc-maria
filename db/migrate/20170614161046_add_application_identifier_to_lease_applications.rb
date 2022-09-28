class AddApplicationIdentifierToLeaseApplications < ActiveRecord::Migration[5.0]
  def change
    add_column :lease_applications, :application_identifier, :string
  end
end

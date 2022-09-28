class AddDisclosureParamsToLeaseApplication < ActiveRecord::Migration[6.0]
  def change
    add_column :lease_applications, :application_disclosure_agreement, :boolean, default: false
    add_column :lease_applications, :submitting_ip_address, :inet
  end
end

class AddRequirePrimaryEmailAddressToCommonApplicationSettings < ActiveRecord::Migration[5.1]
  def change
    add_column :common_application_settings, :require_primary_email_address, :boolean, default: false
  end
end

class AddFundingRequestFormToCommonApplicationSettings < ActiveRecord::Migration[5.1]
  def change
    add_column :common_application_settings, :funding_request_form, :string
  end
end
class AddCompanyTermToApplicationSetting < ActiveRecord::Migration[5.1]
  def change
    add_column :application_settings, :company_term, :string
  end
end

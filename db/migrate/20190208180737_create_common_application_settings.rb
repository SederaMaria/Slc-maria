class CreateCommonApplicationSettings < ActiveRecord::Migration[5.1]
  def change
    create_table :common_application_settings do |t|
      t.string :company_term
      t.string :underwriting_hours
      t.string :funding_approval_checklist
      t.string :power_of_attorney_template
      t.string :illinois_power_of_attorney_template

      t.timestamps null: false
    end
  end
end

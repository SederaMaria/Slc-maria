class CreateIncomeVerificationAttachments < ActiveRecord::Migration[6.0]
  def change
    create_table :income_verification_attachments do |t|
      t.references :income_verification, foreign_key: true, index: true, index: { name: 'index_iva_on_income_verification_id' }
      t.references :lease_application_attachment, foreign_key: true, index: { name: 'index_iva_on_lease_application_attachment_id' }
      t.timestamps
    end
  end
end

class CreateCreditReports < ActiveRecord::Migration[5.1]
  def change
    create_table :credit_reports do |t|
      t.string :status
      t.string :upload
      t.string :identifier
      t.boolean :visible_to_dealers
      t.references :lessee
      t.jsonb :record_errors, default: {}

      t.timestamps
    end
  end
end

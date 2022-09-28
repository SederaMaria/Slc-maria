class CreateCreditReportBankruptcies < ActiveRecord::Migration[6.0]
  def change
    create_table :credit_report_bankruptcies do |t|
      t.string :date_filed
      t.integer :year_filed
      t.integer :month_filed
      t.string :bankruptcy_type
      t.string :bankruptcy_status
      t.string :date_status

      t.references :credit_report

      t.timestamps
    end
  end
end

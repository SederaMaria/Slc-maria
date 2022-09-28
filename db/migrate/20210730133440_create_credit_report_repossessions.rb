class CreateCreditReportRepossessions < ActiveRecord::Migration[6.0]
  def change
    create_table :credit_report_repossessions do |t|
      t.string :date_filed
      t.integer :year_filed
      t.integer :month_filed
      t.string :creditor
      t.string :notes

      t.references :credit_report

      t.timestamps
    end
  end
end

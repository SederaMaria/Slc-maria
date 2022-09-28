class ChangeCreditReportColDefault < ActiveRecord::Migration[5.1]
  def change
    change_column_default :credit_reports, :record_errors, []
  end
end

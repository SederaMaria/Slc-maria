class AddParamsToCreditReport < ActiveRecord::Migration[5.1]
  def change
    add_column :credit_reports, :effective_date, :datetime
    add_column :credit_reports, :end_date, :datetime
    add_column :credit_reports, :credit_score, :integer
  end
end

class AddColumnsToCreditReport < ActiveRecord::Migration[5.1]
  def self.up
    add_column :credit_reports, :credit_score_equifax, :integer
    add_column :credit_reports, :credit_score_experian, :integer
    add_column :credit_reports, :credit_score_transunion, :integer
    add_column :credit_reports, :credit_score_average, :float
  end

  def self.down
    remove_column :credit_reports, :credit_score_equifax, :integer
    remove_column :credit_reports, :credit_score_experian, :integer
    remove_column :credit_reports, :credit_score_transunion, :integer
    remove_column :credit_reports, :credit_score_average, :float
  end    
end

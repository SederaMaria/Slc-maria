class AddCreditDecisionDateToLeaseApplication < ActiveRecord::Migration[5.1]
  def change
    add_column :lease_applications, :credit_decision_date, :datetime
  end
end

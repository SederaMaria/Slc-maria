class AddNotifyColumnsToDealer < ActiveRecord::Migration[5.1]
  def change
    add_column :dealers, :notify_credit_decision, :boolean, default: true
    add_column :dealers, :notify_funding_decision, :boolean, default: true
  end
end

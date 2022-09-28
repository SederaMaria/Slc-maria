class RemoveShortfundFromDealership < ActiveRecord::Migration[5.1]
  def change
    remove_column :dealerships, :is_commission_clawback, :boolean, default: false
    remove_column :dealerships, :commission_clawback_amount, :decimal, precision: 30, scale: 2
    remove_column :dealerships, :change_clawback_amount, :decimal, precision: 30, scale: 2
    remove_column :dealerships, :clawback_reason, :text
  end
end

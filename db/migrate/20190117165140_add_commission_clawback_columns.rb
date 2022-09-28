class AddCommissionClawbackColumns < ActiveRecord::Migration[5.1]
  def change
    add_column :dealerships, :is_commission_clawback, :boolean, default: false
    add_column :dealerships, :commission_clawback_amount, :decimal, precision: 30, scale: 2
    add_column :dealerships, :change_clawback_amount, :decimal, precision: 30, scale: 2
    add_column :dealerships, :clawback_reason, :text

    add_column :lease_applications, :is_dealership_subject_to_clawback, :boolean, default: false
    add_column :lease_applications, :this_deal_dealership_clawback_amount, :decimal, precision: 30, scale: 2
    add_column :lease_applications, :after_this_deal_dealership_clawback_amount, :decimal, precision: 30, scale: 2
  end
end

class AddColumnsToDealership < ActiveRecord::Migration[6.0]
  def change
    add_column :dealerships, :deal_fee_cents, :integer, default: 0, null: false
    add_column :dealerships, :year_incorporated_or_control_year, :integer
    add_column :dealerships, :years_in_business, :integer
    add_column :dealerships, :previously_approved_dealership, :boolean, default: false
    add_column :dealerships, :previous_transactions_submitted, :integer
    add_column :dealerships, :previous_transactions_closed, :integer
    add_column :dealerships, :previous_default_rate, :decimal, precision: 30, scale: 2
  end
end

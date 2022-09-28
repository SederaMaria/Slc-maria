class AddCredcoBooleansToDealership < ActiveRecord::Migration[5.1]
  def change
    add_column :dealerships, :use_experian, :boolean, default: true
    add_column :dealerships, :use_equifax, :boolean, default: false
    add_column :dealerships, :use_transunion, :boolean, default: true
  end
end

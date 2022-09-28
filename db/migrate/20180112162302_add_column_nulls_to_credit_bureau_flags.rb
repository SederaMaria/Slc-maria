class AddColumnNullsToCreditBureauFlags < ActiveRecord::Migration[5.1]
  def change
    change_column_null :dealerships, :use_experian, false
    change_column_null :dealerships, :use_equifax, false
    change_column_null :dealerships, :use_transunion, false
  end
end

class AddDefaultTermValue < ActiveRecord::Migration[5.0]
  def change
    change_column_default :lease_calculators, :term, 24
  end
end

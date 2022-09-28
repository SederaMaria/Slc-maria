class RemoveDefaultTerm < ActiveRecord::Migration[5.0]
  def change
    change_column_default :lease_calculators, :term, to: nil, from: 24

  end
end

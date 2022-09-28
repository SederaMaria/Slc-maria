class RemoveHighestFicoScoreDefault < ActiveRecord::Migration[5.0]
  def change
    change_column_default(:lessees, :highest_fico_score, from: 0, to: nil)
  end
end

class AddHighestFicoScoreToLessee < ActiveRecord::Migration[5.0]
  def change
    add_column :lessees, :highest_fico_score, :integer, default: 0
  end
end

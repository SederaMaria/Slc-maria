class AddFirstTimeRiderToLessees < ActiveRecord::Migration[6.0]
  def change
    add_column :lessees, :first_time_rider, :boolean
  end
end

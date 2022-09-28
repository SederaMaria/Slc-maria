class AddTimestampsToLessees < ActiveRecord::Migration[5.0]
  def change
    add_timestamps(:lessees, null: true)
    Lessee.update_all(created_at: Time.zone.now, updated_at: Time.zone.now)
    change_column_null :lessees, :created_at, false
    change_column_null :lessees, :updated_at, false
  end
end

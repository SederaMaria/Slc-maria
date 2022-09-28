class AddAdvanceHaircutsToMileageTiers < ActiveRecord::Migration[5.0]
  def up
    change_table :mileage_tiers do |t|
      10.times do |i|
        t.decimal :"maximum_frontend_advance_haircut_#{i}", default: 0, null: false, scale: 2, precision: 4
      end
    end
  end

  def down
    10.times do |i|
      remove_column :mileage_tiers, :"maximum_frontend_advance_haircut_#{i}"
    end
  end
end

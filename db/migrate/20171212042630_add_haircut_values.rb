class AddHaircutValues < ActiveRecord::Migration[5.1]
  def change
    change_table :model_groups do |t|
      10.times do |i|
        t.decimal :"maximum_haircut_#{i}", default: 1, null: false, scale: 2, precision: 4
      end
    end

    change_table :model_years do |t|
      10.times do |i|
        t.decimal :"maximum_haircut_#{i}", default: 1, null: false, scale: 2, precision: 4
      end
    end
  end
end
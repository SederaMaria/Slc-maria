class AddMoreHaircuts < ActiveRecord::Migration[5.1]
  
  TEN_TO_FOURTEEN = 10.upto(14)
  
  def up
    change_table :mileage_tiers do |t|
      TEN_TO_FOURTEEN.each do |i|
        t.decimal :"maximum_frontend_advance_haircut_#{i}", default: 0, null: false, scale: 2, precision: 4
      end
    end

    change_table :model_groups do |t|
      TEN_TO_FOURTEEN.each do |i|
        t.decimal :"maximum_haircut_#{i}", default: 1, null: false, scale: 2, precision: 4
      end
    end

    change_table :model_years do |t|
      TEN_TO_FOURTEEN.each do |i|
        t.decimal :"maximum_haircut_#{i}", default: 1, null: false, scale: 2, precision: 4
      end
    end
  end

  def down
    TEN_TO_FOURTEEN.each do |i|
      remove_column :mileage_tiers, :"maximum_frontend_advance_haircut_#{i}"
      remove_column :model_groups, :"maximum_haircut_#{i}"
      remove_column :model_years, :"maximum_haircut_#{i}"
    end
  end
end

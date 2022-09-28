# column "Minimum F&I Advance", :minimum_backend_advance
# column "F&I Advance", :back_end_max
# column "Advance", :max_adv

class ChangeCreditTierFields < ActiveRecord::Migration[5.0]
  def up
    remove_columns :credit_tiers, :motorcycle_max_advance_cents, :f_and_i_max_advance_cents, :f_and_i_min_advance_cents, :money_factor
    
    change_table :credit_tiers do |t|
      t.decimal :minimum_fi_advance_percentage, precision: 4, scale: 2 #must store 10.25
      t.decimal :maximum_fi_advance_percentage, precision: 4, scale: 2 #must store 10.25
      t.decimal :maximum_advance_percentage, precision: 4, scale: 2 #must store 10.25
    end
  end

  def down
    raise('No reason to roll this back')
  end
end

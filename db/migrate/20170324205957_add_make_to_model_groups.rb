class AddMakeToModelGroups < ActiveRecord::Migration[5.0]
  def change
    add_reference :model_groups, :make, foreign_key: true, index: true
  end
end

class AddMakeToSlcModelGroups < ActiveRecord::Migration[5.1]
  def change
  	add_reference :slc_model_groups, :make, foreign_key: true, index: true
  end
end

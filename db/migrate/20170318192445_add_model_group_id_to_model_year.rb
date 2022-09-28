class AddModelGroupIdToModelYear < ActiveRecord::Migration[5.0]
  def change
    add_reference :model_years, :model_group
  end
end

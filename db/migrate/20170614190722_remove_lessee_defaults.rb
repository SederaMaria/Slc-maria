class RemoveLesseeDefaults < ActiveRecord::Migration[5.0]
  def change
    change_column_default :lessees, :home_ownership, nil
    change_column_default :lessees, :employment_status, nil
  end
end

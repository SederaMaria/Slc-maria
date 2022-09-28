class AddRelationshipAndIsDrivingToLessee < ActiveRecord::Migration[6.0]
  def change
    add_column :lessees, :is_driving, :boolean, default: false
    add_reference :lessees, :relationship_to_lessee
  end
end

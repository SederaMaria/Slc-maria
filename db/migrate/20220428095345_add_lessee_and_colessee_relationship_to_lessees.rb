class AddLesseeAndColesseeRelationshipToLessees < ActiveRecord::Migration[6.0]
  def change
    add_column :lessees, :lessee_and_colessee_relationship, :string
  end
end

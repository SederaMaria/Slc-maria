class AddMotorcycleLicenceToLessees < ActiveRecord::Migration[6.0]
  def change
    add_column :lessees, :motorcycle_licence, :boolean
  end
end

class CreateRelationshipToLessees < ActiveRecord::Migration[6.0]
  def change
    create_table :relationship_to_lessees do |t|
      t.string    :description
      t.boolean :active, default: true
      t.timestamps
    end
  end
end

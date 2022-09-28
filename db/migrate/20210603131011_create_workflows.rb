class CreateWorkflows < ActiveRecord::Migration[6.0]
  def change
    create_table :workflows do |t|
      t.string :workflow_name, unique: true

      t.timestamps
    end
  end
end

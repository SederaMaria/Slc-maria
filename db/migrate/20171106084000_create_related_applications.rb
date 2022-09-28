class CreateRelatedApplications < ActiveRecord::Migration[5.1]
  def change
    create_table :related_applications do |t|
      t.integer :origin_application_id, null: false
      t.integer :related_application_id, null: false

      t.timestamps
    end
  end
end

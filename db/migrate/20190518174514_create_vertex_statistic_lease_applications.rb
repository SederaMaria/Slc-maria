class CreateVertexStatisticLeaseApplications < ActiveRecord::Migration[5.1]
  def change
    create_table :vertex_statistic_lease_applications do |t|
      t.string :lease_application_id
      t.integer :vertex_statistic_id, foreign_key: true

      t.timestamps
    end
  end
end

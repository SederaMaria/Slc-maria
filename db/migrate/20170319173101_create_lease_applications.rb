class CreateLeaseApplications < ActiveRecord::Migration[5.0]
  def change
    create_table :lease_applications do |t|
      t.references :lessee
      t.references :colessee
      t.references :dealer
      t.string :status
      t.references :lease_calculator
      t.timestamps
    end
  end
end

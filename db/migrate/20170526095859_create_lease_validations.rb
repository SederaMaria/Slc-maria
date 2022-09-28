class CreateLeaseValidations < ActiveRecord::Migration[5.0]
  def change
    create_table :lease_validations do |t|
      t.references :lease_application, foreign_key: true
      t.references :validatable, polymorphic: true, index: true
      t.string :type
      t.string :status
      t.string :original_value
      t.string :revised_value

      t.timestamps
    end
  end
end

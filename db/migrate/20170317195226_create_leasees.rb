class CreateLeasees < ActiveRecord::Migration[5.0]
  def change
    create_table :lessees do |t|
      t.string    :first_name
      t.string    :middle_name
      t.string    :last_name
      t.datetime  :date_of_birth
      t.string    :ssn
      t.string    :mobile_phone
      t.string    :home_phone
      t.timestamps
    end
  end
end

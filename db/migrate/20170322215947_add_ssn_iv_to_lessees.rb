class AddSsnIvToLessees < ActiveRecord::Migration[5.0]
  def change
    add_column :lessees, :encrypted_ssn_iv, :string
  end
end

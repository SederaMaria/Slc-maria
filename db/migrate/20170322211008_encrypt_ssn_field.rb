class EncryptSsnField < ActiveRecord::Migration[5.0]
  def up
    rename_column :lessees, :ssn, :encrypted_ssn
    Lessee.update_all(:encrypted_ssn => nil)
  end

  def down
    rename_column :lessees, :encrypted_ssn, :ssn
  end
end

class RenameLpcManfToLmsManf < ActiveRecord::Migration[6.0]
  def change
    rename_column :makes, :lpc_manf, :lms_manf
  end
end

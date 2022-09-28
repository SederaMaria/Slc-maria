class AddBorrowerIdToCredco < ActiveRecord::Migration[6.0]
  def change
     add_column :lease_application_credcos, :borrower_id_score, :string
  end
end

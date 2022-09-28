class ChangeSubmittedAtToSubmittedOn < ActiveRecord::Migration[5.1]
  def change
    change_column :lease_applications, :submitted_at, :date
  end
end

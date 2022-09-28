class RemoveAttachmentsFromLeaseApplicationStipulation < ActiveRecord::Migration[5.1]
  def change
    remove_columns :lease_application_stipulations, :attachment
  end
end

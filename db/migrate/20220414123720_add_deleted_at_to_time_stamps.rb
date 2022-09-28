class AddDeletedAtToTimeStamps < ActiveRecord::Migration[6.0]
  def change
    add_column :lessees, :deleted_at, :datetime
  end
end

class RemoveDestroyedColesseesTable < ActiveRecord::Migration[5.1]
  def up
    drop_table :deleted_colessees
  end

  def down
    raise IrreversibleMigrationError
  end
end

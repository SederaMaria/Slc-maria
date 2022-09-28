class AddParentToAudit < ActiveRecord::Migration[5.1]
  def change
    add_column :audits, :parent_id, :integer
    add_column :audits, :parent_type, :string
  end
end

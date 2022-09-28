class AddBlocksCreditStatusToStipulations < ActiveRecord::Migration[6.0]
  def change
    add_column :stipulations, :blocks_credit_status_approved, :boolean, default: false, null: false
  end
end

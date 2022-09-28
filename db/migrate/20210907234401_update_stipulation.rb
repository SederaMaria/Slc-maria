class UpdateStipulation < ActiveRecord::Migration[6.0]
  def change
    add_column :stipulations, :verification_call_problem, :boolean, default: false
  end
end

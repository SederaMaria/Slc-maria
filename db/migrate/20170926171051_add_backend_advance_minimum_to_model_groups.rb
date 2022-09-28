class AddBackendAdvanceMinimumToModelGroups < ActiveRecord::Migration[5.0]
  def change
    add_monetize :model_groups, :backend_advance_minimum
  end
end

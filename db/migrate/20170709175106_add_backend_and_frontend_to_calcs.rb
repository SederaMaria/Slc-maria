class AddBackendAndFrontendToCalcs < ActiveRecord::Migration[5.0]
  def change
    add_monetize :lease_calculators, :backend_total, default: 0, null: false
    add_monetize :lease_calculators, :frontend_total, default: 0, null: false
  end
end

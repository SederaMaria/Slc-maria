class AddBlackboxToDatax < ActiveRecord::Migration[6.0]
  def change
    add_column :lease_application_dataxes, :blackbox_endpoint, :string
  end
end

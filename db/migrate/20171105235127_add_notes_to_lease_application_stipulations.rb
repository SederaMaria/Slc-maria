class AddNotesToLeaseApplicationStipulations < ActiveRecord::Migration[5.1]
  def change
    add_column :lease_application_stipulations, :notes, :text
  end
end

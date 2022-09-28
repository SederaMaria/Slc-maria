class AddDefautStatusToStipulations < ActiveRecord::Migration[5.0]
  def change
    change_column_default :lease_application_stipulations, :status, from: nil, to: 'Required'
    change_column_null :lease_application_stipulations, :status, false
  end
end

class AddCanSeeWelcomeCallDashboard < ActiveRecord::Migration[5.1]
  def change
    add_column :security_roles, :can_see_welcome_call_dashboard, :boolean, default: false
  end
end

class AddColumnDeactivateDealerParticipationToCommonApplicationSettings < ActiveRecord::Migration[5.1]
  def change
  	add_column :common_application_settings, :deactivate_dealer_participation, :boolean, default: false
  end
end

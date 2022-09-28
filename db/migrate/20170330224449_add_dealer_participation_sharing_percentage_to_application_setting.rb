class AddDealerParticipationSharingPercentageToApplicationSetting < ActiveRecord::Migration[5.0]
  def change
    add_column :application_settings, :dealer_participation_sharing_percentage, :decimal, null: false, default: 50.0 #%
  end
end

class AddDealerParticipationSharingPercentage60ToApplicationSettings < ActiveRecord::Migration[5.0]
  def change
    add_column :application_settings, :dealer_participation_sharing_percentage_60, :decimal, default: 0.0, null: false
  end
end

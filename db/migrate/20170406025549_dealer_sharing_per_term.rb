class DealerSharingPerTerm < ActiveRecord::Migration[5.0]
  def change
    rename_column :application_settings, :dealer_participation_sharing_percentage, :dealer_participation_sharing_percentage_24
    add_column :application_settings, :dealer_participation_sharing_percentage_36, :decimal, default: 0, null: false
    add_column :application_settings, :dealer_participation_sharing_percentage_48, :decimal, default: 0, null: false
  end
end

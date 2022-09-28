class AddMinimumDealerParticipationToModelGroups < ActiveRecord::Migration[5.0]
  def change
    add_monetize :model_groups, :minimum_dealer_participation
  end
end

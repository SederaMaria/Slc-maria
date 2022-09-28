class AddCanSeeBannerToDealerships < ActiveRecord::Migration[5.1]
  def change
    add_column :dealerships, :can_see_banner, :boolean, default: true
  end
end

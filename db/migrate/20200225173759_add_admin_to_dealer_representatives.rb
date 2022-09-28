class AddAdminToDealerRepresentatives < ActiveRecord::Migration[5.1]
  def change
    add_reference :dealer_representatives, :admin_user, foreign_key: true
  end
end

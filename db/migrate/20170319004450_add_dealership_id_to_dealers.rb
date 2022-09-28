class AddDealershipIdToDealers < ActiveRecord::Migration[5.0]
  def change
    add_reference :dealers, :dealership
  end
end

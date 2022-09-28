class AddLesseeToLeaseApplicationDatax < ActiveRecord::Migration[5.1]
  def change
    add_reference :lease_application_dataxes, :lessee, foreign_key: true
  end
end

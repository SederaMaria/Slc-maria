class AddMailCarrierToLeaseApplication < ActiveRecord::Migration[5.1]
  def change
    add_reference :lease_applications, :mail_carrier, foreign_key: true
  end
end

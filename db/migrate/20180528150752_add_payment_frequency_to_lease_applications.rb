class AddPaymentFrequencyToLeaseApplications < ActiveRecord::Migration[5.1]
  def change
    change_table :lease_applications do |t|
      t.integer :payment_frequency
      t.integer :payment_first_day
      t.integer :payment_second_day
      t.date :second_payment_date
    end
  end
end

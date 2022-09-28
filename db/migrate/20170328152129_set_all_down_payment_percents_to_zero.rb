class SetAllDownPaymentPercentsToZero < ActiveRecord::Migration[5.0]
  def change
    CreditTier.update_all required_down_payment_percentage: 0.00
  end
end

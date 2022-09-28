class UpdateOnlineVerificationCallChecklist < ActiveRecord::Migration[6.0]
  def change
    change_table :online_verification_call_checklists do |t|
      t.integer :vehicle_mileage
      t.string :vin_number_last_six
      t.string :vehicle_color
      t.boolean :bike_in_working_order
      t.boolean :lessee_confirm_residual_value
      t.string :lessee_available_to_speak_string
      t.string :lessee_social_security_confirm_comment
      t.string :lessee_date_of_birth_confirm_comment
      t.string :lessee_street_address_confirm_comment
      t.string :lessee_can_receive_text_messages_comment
      t.string :lease_term_confirm_comment
      t.string :monthly_payment_confirm_comment
      t.string :payment_frequency_confirm_comment
      t.string :first_payment_date_confirm_comment
      t.string :second_payment_date_confirm_comment
      t.string :due_dates_match_lessee_pay_date_comment
      t.string :lessee_has_test_driven_bike_comment
      t.string :bike_in_working_order_comment
      t.boolean :issue, default: false
    end
  end
end

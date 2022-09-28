class CreateOnlineVerificationCallChecklists < ActiveRecord::Migration[6.0]
  def change
    create_table :online_verification_call_checklists do |t|
      t.references :lease_application, index: { name: 'index_ovc_checklists_on_lease_application' }

      t.boolean :lessee_available_to_speak
      t.boolean :lessee_social_security_confirm
      t.boolean :lessee_date_of_birth_confirm
      t.boolean :lessee_street_address_confirm
      t.string :lessee_email
      t.string :lessee_best_phone_number
      t.boolean :lessee_can_receive_text_messages
      t.boolean :lease_term_confirm
      t.boolean :monthly_payment_confirm
      t.boolean :payment_frequency_confirm
      t.integer :payment_frequency_type, limit: 1
      t.boolean :first_payment_date_confirm
      t.boolean :second_payment_date_confirm
      t.boolean :due_dates_match_lessee_pay_date
      t.integer :lessee_reported_year
      t.string :lessee_reported_make
      t.string :lessee_reported_model
      t.boolean :lessee_has_test_driven_bike
      t.string :notes

      t.timestamps
    end
  end
end

# == Schema Information
#
# Table name: online_verification_call_checklists
#
#  id                                       :bigint(8)        not null, primary key
#  lease_application_id                     :bigint(8)
#  lessee_available_to_speak                :boolean
#  lessee_social_security_confirm           :boolean
#  lessee_date_of_birth_confirm             :boolean
#  lessee_street_address_confirm            :boolean
#  lessee_email                             :string
#  lessee_best_phone_number                 :string
#  lessee_can_receive_text_messages         :boolean
#  lease_term_confirm                       :boolean
#  monthly_payment_confirm                  :boolean
#  payment_frequency_confirm                :boolean
#  payment_frequency_type                   :integer
#  first_payment_date_confirm               :boolean
#  second_payment_date_confirm              :boolean
#  due_dates_match_lessee_pay_date          :boolean
#  lessee_reported_year                     :integer
#  lessee_reported_make                     :string
#  lessee_reported_model                    :string
#  lessee_has_test_driven_bike              :boolean
#  notes                                    :string
#  created_at                               :datetime         not null
#  updated_at                               :datetime         not null
#  completed_by_id                          :bigint(8)
#  vehicle_mileage                          :integer
#  vin_number_last_six                      :string
#  vehicle_color                            :string
#  bike_in_working_order                    :boolean
#  lessee_confirm_residual_value            :boolean
#  lessee_available_to_speak_string         :string
#  lessee_social_security_confirm_comment   :string
#  lessee_date_of_birth_confirm_comment     :string
#  lessee_street_address_confirm_comment    :string
#  lessee_can_receive_text_messages_comment :string
#  lease_term_confirm_comment               :string
#  monthly_payment_confirm_comment          :string
#  payment_frequency_confirm_comment        :string
#  first_payment_date_confirm_comment       :string
#  second_payment_date_confirm_comment      :string
#  due_dates_match_lessee_pay_date_comment  :string
#  lessee_has_test_driven_bike_comment      :string
#  bike_in_working_order_comment            :string
#  issue                                    :boolean          default(FALSE)
#
# Indexes
#
#  index_online_verification_call_checklists_on_completed_by_id  (completed_by_id)
#  index_ovc_checklists_on_lease_application                     (lease_application_id)
#
class OnlineVerificationCallChecklistSerializer < ApplicationSerializer
  attributes :lessee_available_to_speak, :lessee_social_security_confirm, :lessee_date_of_birth_confirm,
    :lessee_street_address_confirm, :lessee_email, :lessee_best_phone_number, :lessee_can_receive_text_messages,
    :lease_term_confirm, :monthly_payment_confirm, :payment_frequency_confirm, :payment_frequency_type,
    :first_payment_date_confirm, :second_payment_date_confirm, :due_dates_match_lessee_pay_date,
    :lessee_reported_year, :lessee_reported_make, :lessee_reported_model, :lessee_has_test_driven_bike, :notes,
    :created_at, :updated_at, :completed_by, :vehicle_mileage, :vin_number_last_six, :vehicle_color, 
    :bike_in_working_order, :lessee_confirm_residual_value, :lessee_available_to_speak_comment, 
    :lessee_social_security_confirm_comment, :lessee_date_of_birth_confirm_comment, 
    :lessee_street_address_confirm_comment, :lessee_can_receive_text_messages_comment, 
    :lease_term_confirm_comment, :monthly_payment_confirm_comment, :payment_frequency_confirm_comment, 
    :first_payment_date_confirm_comment, :second_payment_date_confirm_comment, 
    :due_dates_match_lessee_pay_date_comment, :lessee_has_test_driven_bike_comment, 
    :bike_in_working_order_comment, :issue, :lessee_confirm_residual_value_comment

  def completed_by
    object&.completed_by&.full_name
  end
end

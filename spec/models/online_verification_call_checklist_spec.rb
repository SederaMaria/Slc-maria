# == Schema Information
#
# Table name: online_verification_call_checklists
#
#  id                               :bigint(8)        not null, primary key
#  lease_application_id             :bigint(8)
#  lessee_available_to_speak        :boolean
#  lessee_social_security_confirm   :boolean
#  lessee_date_of_birth_confirm     :boolean
#  lessee_street_address_confirm    :boolean
#  lessee_email                     :string
#  lessee_best_phone_number         :string
#  lessee_can_receive_text_messages :boolean
#  lease_term_confirm               :boolean
#  monthly_payment_confirm          :boolean
#  payment_frequency_confirm        :boolean
#  payment_frequency_type           :integer
#  first_payment_date_confirm       :boolean
#  second_payment_date_confirm      :boolean
#  due_dates_match_lessee_pay_date  :boolean
#  lessee_reported_year             :integer
#  lessee_reported_make             :string
#  lessee_reported_model            :string
#  lessee_has_test_driven_bike      :boolean
#  notes                            :string
#  created_at                       :datetime         not null
#  updated_at                       :datetime         not null
#  completed_by_id                  :bigint(8)
#
# Indexes
#
#  index_online_verification_call_checklists_on_completed_by_id  (completed_by_id)
#  index_ovc_checklists_on_lease_application                     (lease_application_id)
#
require 'rails_helper'

RSpec.describe OnlineVerificationCallChecklist, type: :model do
  it { should belong_to(:lease_application) }
  it { should belong_to(:completed_by) }

  it 'creates correctly' do
    record = create(:online_verification_call_checklist)
    expect(record).to be_valid
    expect(record).to be_persisted
  end
end

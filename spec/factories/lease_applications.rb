# == Schema Information
#
# Table name: lease_applications
#
#  id                                         :integer          not null, primary key
#  lessee_id                                  :integer
#  colessee_id                                :integer
#  dealer_id                                  :integer
#  lease_calculator_id                        :integer
#  created_at                                 :datetime         not null
#  updated_at                                 :datetime         not null
#  document_status                            :string           default("no_documents"), not null
#  credit_status                              :string           default("unsubmitted"), not null
#  submitted_at                               :date
#  expired                                    :boolean          default(FALSE)
#  application_identifier                     :string
#  documents_issued_date                      :date
#  dealership_id                              :integer
#  lease_package_received_date                :datetime
#  credit_decision_date                       :datetime
#  funding_delay_on                           :date
#  funding_approved_on                        :date
#  funded_on                                  :date
#  first_payment_date                         :date
#  payment_aba_routing_number                 :string
#  payment_account_number                     :string
#  payment_bank_name                          :string
#  payment_account_type                       :integer          default(NULL)
#  payment_frequency                          :integer
#  payment_first_day                          :integer
#  payment_second_day                         :integer
#  second_payment_date                        :date
#  promotion_name                             :string
#  promotion_value                            :float
#  is_dealership_subject_to_clawback          :boolean          default(FALSE)
#  this_deal_dealership_clawback_amount       :decimal(30, 2)
#  after_this_deal_dealership_clawback_amount :decimal(30, 2)
#  city_id                                    :bigint(8)
#  vehicle_possession                         :string
#  payment_account_holder                     :string
#  welcome_call_due_date                      :datetime
#  department_id                              :bigint(8)
#  is_verification_call_completed             :boolean          default(FALSE)
#  is_exported_to_access_db                   :boolean          default(FALSE)
#  requested_by                               :integer
#  approved_by                                :integer
#  prenote_status                             :string
#  mail_carrier_id                            :bigint(8)
#  workflow_status_id                         :bigint(8)
#
# Indexes
#
#  index_lease_applications_on_application_identifier  (application_identifier) UNIQUE WHERE (application_identifier IS NOT NULL)
#  index_lease_applications_on_city_id                 (city_id)
#  index_lease_applications_on_colessee_id             (colessee_id)
#  index_lease_applications_on_dealer_id               (dealer_id)
#  index_lease_applications_on_dealership_id           (dealership_id)
#  index_lease_applications_on_department_id           (department_id)
#  index_lease_applications_on_lease_calculator_id     (lease_calculator_id)
#  index_lease_applications_on_lessee_id               (lessee_id)
#  index_lease_applications_on_mail_carrier_id         (mail_carrier_id)
#  index_lease_applications_on_workflow_status_id      (workflow_status_id)
#
# Foreign Keys
#
#  fk_rails_...  (city_id => cities.id)
#  fk_rails_...  (colessee_id => lessees.id)
#  fk_rails_...  (dealer_id => dealers.id)
#  fk_rails_...  (dealership_id => dealerships.id)
#  fk_rails_...  (department_id => departments.id)
#  fk_rails_...  (lease_calculator_id => lease_calculators.id)
#  fk_rails_...  (lessee_id => lessees.id)
#  fk_rails_...  (mail_carrier_id => mail_carriers.id)
#  fk_rails_...  (workflow_status_id => workflow_statuses.id)
#

FactoryBot.define do
  factory :lease_application do
    lessee
    association :colessee, factory: :lessee
    lease_calculator
    dealership
    dealer
    workflow_status
    
    documents_issued_date { Date.current - 2.days }
    credit_decision_date { Date.today - 3.days }
    lease_package_received_date { Date.current - 1.day }

    trait :funded do
      funding_delay_on    { Date.yesterday }
      funding_approved_on { Date.current }
      funded_on           { Date.tomorrow }
    end

    trait :expired do
      expired { true }
    end

    trait :unsubmitted do
      credit_status { 'unsubmitted' }
    end

    trait :submitted do
      sequence(:application_identifier) { |n| '%010d' % n }
      submitted_at { Time.zone.now }
    end

    trait :submittable do
      #same as standard factory, here to help make specs a bit more clear
    end

    trait :no_documents do
      document_status { 'no_documents' }
    end

    trait :documents_requested do
      document_status { 'documents_requested' }
    end
    trait :documents_issued do
      document_status { 'documents_issued' }
    end
    trait :lease_package_received do
      document_status { 'lease_package_received' }
    end
    trait :funding_delay do
      document_status { 'funding_delay' }
    end
    trait :funding_approved do
      document_status { 'funding_approved' }
    end
    trait :funded do
      document_status { 'funded' }
    end
    trait :canceled do
      document_status { 'canceled' }
    end

    trait :approved do
      credit_status { 'approved' }
    end

    trait :awaiting_credit_decision do
      credit_status { 'awaiting_credit_decision' }
    end

    trait :approved_with_contingencies do
      credit_status { 'approved_with_contingencies' }
    end

    trait :requires_additional_information do
      credit_status { 'requires_additional_information' }
    end

    trait :declined do
      credit_status { 'declined' }
    end

    trait :rescinded do
      credit_status { 'rescinded' }
    end

    trait :withdrawn do
      credit_status { 'withdrawn' }
    end

    trait :can_request_lease_documents do
      sequence(:application_identifier) { |n| '%010d' % n }
      credit_status { 'approved' }
      document_status { 'no_documents' }
      expired { false }
    end

    trait :with_requested_documents do
      after(:build) do |obj|
        obj.lease_document_requests.append(FactoryBot.create(:lease_document_request))
      end
    end

    trait :lessee_with_addresses_and_phone_numbers do
      association :lessee, :with_addresses, :with_valid_phone_numbers
    end

    trait :all_texas do
      after(:build) do |obj|
        obj.dealership.state =  'TX'
        obj.lessee.home_address.state = 'TX'
        obj.lease_document_requests.append(FactoryBot.create(:lease_document_request))
      end
    end

    trait :with_four_references do
      after(:create) do |obj|
        4.times do
          FactoryBot.create(:reference, lease_application: obj)
        end
      end
    end
  end
end

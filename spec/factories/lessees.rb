# == Schema Information
#
# Table name: lessees
#
#  id                                :integer          not null, primary key
#  first_name                        :string
#  middle_name                       :string
#  last_name                         :string
#  suffix                            :string
#  encrypted_ssn                     :string
#  date_of_birth                     :date
#  mobile_phone_number               :string
#  home_phone_number                 :string
#  drivers_license_id_number         :string
#  drivers_license_state             :string
#  email_address                     :string
#  employment_details                :string
#  home_address_id                   :integer
#  mailing_address_id                :integer
#  employment_address_id             :integer
#  encrypted_ssn_iv                  :string
#  at_address_years                  :integer
#  at_address_months                 :integer
#  monthly_mortgage                  :decimal(, )
#  home_ownership                    :integer
#  drivers_licence_expires_at        :date
#  employer_name                     :string
#  time_at_employer_years            :integer
#  time_at_employer_months           :integer
#  job_title                         :string
#  employment_status                 :integer
#  employer_phone_number             :string
#  gross_monthly_income              :decimal(, )
#  other_monthly_income              :decimal(, )
#  created_at                        :datetime         not null
#  updated_at                        :datetime         not null
#  highest_fico_score                :integer
#  deleted_from_lease_application_id :bigint(8)
#  mobile_phone_number_line          :string
#  mobile_phone_number_carrier       :string
#  home_phone_number_line            :string
#  home_phone_number_carrier         :string
#  employer_phone_number_line        :string
#  employer_phone_number_carrier     :string
#  ssn                               :text
#  proven_monthly_income             :decimal(, )
#
# Indexes
#
#  index_lessees_on_deleted_from_lease_application_id  (deleted_from_lease_application_id)
#  index_lessees_on_employment_address_id              (employment_address_id)
#  index_lessees_on_home_address_id                    (home_address_id)
#  index_lessees_on_mailing_address_id                 (mailing_address_id)
#
# Foreign Keys
#
#  fk_rails_...  (deleted_from_lease_application_id => lease_applications.id)
#

FactoryBot.define do
  factory :lessee do
    email_address  { FFaker::Internet.unique.email }
    first_name     { FFaker::Name.first_name }
    middle_name    { FFaker::Name.first_name }
    last_name      { FFaker::Name.last_name }
    ssn            { FFaker::SSN.ssn }
    date_of_birth  { Random.new.rand(18..100).years.ago } #random birthday between 18 and 100 years ago
    employment_details { 'Gainfully employed at LD Studios' }
    employer_name  { 'LD Studios' }
    highest_fico_score { '720' }
    with_addresses
    with_valid_phone_numbers

    trait :with_valid_phone_numbers do
      home_phone_number     { '4043764434' }
      mobile_phone_number   { '7703174866' }
      employer_phone_number { '4043764434' }
    end

    trait :with_addresses do
      association :mailing_address, factory: :address
      association :home_address, factory: :address
      association :employment_address, factory: :address
    end

    trait :submittable do
      association :home_address, factory: :address
      association :employment_address, factory: :address      
      monthly_mortgage { 1234.56 }
      home_ownership { :own }
      time_at_employer_years { 5 }
      job_title { 'Ruby on Rails Developer' }
      employment_status { :employed }
      employer_phone_number { '4043764434' }
      gross_monthly_income { 1234.56 }
      other_monthly_income { 1.00 }
      at_address_years { 2 }
      home_phone_number { '4043764434' } 
    end

    trait :credco_test do
      first_name { 'Edwin' }
      last_name { 'Inquiry' }
      ssn { '007277697' }
      date_of_birth { Date.new(1980, 1, 1) }
      home_phone_number { '(302) 555-1212' }

      home_address do 
        create(:address, 
        street1: '1025 Gateway Blvd',
        city: 'Boynton Beach',
        state: 'FL',
        zipcode: '33426')
      end
    end
  end
end

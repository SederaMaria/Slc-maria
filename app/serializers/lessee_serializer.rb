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

class LesseeSerializer < ApplicationSerializer
  attributes :id, :first_name, :middle_name, :last_name, :first_time_rider, :motorcycle_licence, :suffix, :date_of_birth, :drivers_license_id_number, :ssn, :city, :state, :zipcode, :home_phone_number,
             :at_address_years, :at_address_months, :monthly_mortgage, :proven_monthly_income,
             :employer_name, :employer_phone_number, :employment_status, :home_ownership,
             :employment_details, :time_at_employer_years, :time_at_employer_months, :job_title, :gross_monthly_income,
             :mobile_phone_number, :email_address, :street1, :street2, :full_name, :home_address, :mailing_address, :employment_address, :income_verifications,
             :relationship_to_lessee_id, :is_driving, :lessee_and_colessee_relationship, :ssn_changed

  def relationship_to_lessee_id
    object&.relationship_to_lessee_id&.to_s
  end

  def is_driving
    object&.is_driving ? 1 : 0
  end

  def full_name
    object&.full_name
  end

  def city
    object&.home_address&.new_city_value
  end

  def new_city_collection_value
    object&.home_address&.new_city_collection_value
  end

  def state
    object&.home_address&.state
  end

  def street1
    object&.home_address&.street1
  end

  def street2
    object&.home_address&.street2
  end

  def zipcode
    object&.home_address&.zipcode
  end

  def date_of_birth
    object&.date_of_birth&.strftime('%B %d, %Y')
  end

  def employment_status
    object&.employment_status_definition&.definition&.humanize
  end

  def home_ownership
    object&.read_attribute_before_type_cast('home_ownership')
  end

  def home_address
    ActiveModelSerializers::SerializableResource.new(object&.home_address)
  end

  def mailing_address
    ActiveModelSerializers::SerializableResource.new(object&.mailing_address)
  end

  def employment_address
    ActiveModelSerializers::SerializableResource.new(object&.employment_address)
  end

  def income_verifications
    ActiveModelSerializers::SerializableResource.new(object&.income_verifications&.order(created_at: :desc),
                                                     each_serializer: IncomeVerificationSerializer, key_transform: :camel_lower)
  end
end

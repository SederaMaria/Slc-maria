# == Schema Information
#
# Table name: lessees
#
#  id                         :integer          not null, primary key
#  first_name                 :string
#  middle_initial             :string(1)
#  last_name                  :string
#  suffix                     :string
#  encrypted_ssn              :string
#  date_of_birth              :date
#  mobile_phone_number        :string
#  home_phone_number          :string
#  drivers_license_id_number  :string
#  drivers_license_state      :string
#  email_address              :string
#  employment_details         :string
#  home_address_id            :integer
#  mailing_address_id         :integer
#  employment_address_id      :integer
#  encrypted_ssn_iv           :string
#  at_address_years           :integer
#  at_address_months          :integer
#  monthly_mortgage           :decimal(, )
#  home_ownership             :integer
#  drivers_licence_expires_at :date
#  employer_name              :string
#  time_at_employer_years     :integer
#  time_at_employer_months    :integer
#  job_title                  :string
#  employment_status          :integer
#  employer_phone_number      :string
#  gross_monthly_income       :decimal(, )
#  other_monthly_income       :decimal(, )
#
module Lessees
  module LeasePackageDocumentMethods
    def stay_length
      (at_address_years.to_i * 12) + at_address_months.to_i
    end

    def addr_stat
      home_ownership
    end

    def monthly_pymt
      monthly_mortgage
    end

    def emp_length
      (time_at_employer_years.to_i * 12) + time_at_employer_months.to_i
    end

    def home_phone
      home_phone_number
    end

    def cell_phone
      mobile_phone_number
    end

    def use_phy_addr
      !mailing_address.present?
    end

    def emp_name
      employer_name
    end
  end
end
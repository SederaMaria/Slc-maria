# == Schema Information
#
# Table name: insurance_companies
#
#  id           :bigint(8)        not null, primary key
#  company_name :string
#  company_code :string
#  created_at   :datetime         not null
#  updated_at   :datetime         not null
#

class InsuranceCompany < ApplicationRecord
  belongs_to :lease_application
end

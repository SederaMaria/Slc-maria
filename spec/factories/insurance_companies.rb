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

FactoryBot.define do
  factory :insurance_company do
    company_name { "MyString" }
    company_code { "MyString" }
    lease_application { nil }
  end
end

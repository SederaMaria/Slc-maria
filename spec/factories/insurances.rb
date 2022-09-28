# == Schema Information
#
# Table name: insurances
#
#  id                           :bigint(8)        not null, primary key
#  company_name                 :string
#  bodily_injury_per_person     :string
#  bodily_injury_per_occurrence :string
#  comprehensive                :string
#  collision                    :string
#  property_damage              :string
#  effective_date               :date
#  expiration_date              :date
#  loss_payee                   :boolean
#  additional_insured           :boolean
#  lease_application_id         :bigint(8)
#  created_at                   :datetime         not null
#  updated_at                   :datetime         not null
#  insurance_company_id         :bigint(8)
#  policy_number                :string
#
# Indexes
#
#  index_insurances_on_insurance_company_id  (insurance_company_id)
#  index_insurances_on_lease_application_id  (lease_application_id)
#
# Foreign Keys
#
#  fk_rails_...  (insurance_company_id => insurance_companies.id)
#

FactoryBot.define do
  factory :insurance do
    
  end
end

FactoryBot.define do
  factory :income_verification do
    lessee
    income_verification_type
    income_frequency
    lease_application_attachment

    employer_client { 'Employer' }
    gross_income_cents { 1 }

    created_by_admin { create(:admin_user) }
    updated_by_admin { create(:admin_user) }
  end
end

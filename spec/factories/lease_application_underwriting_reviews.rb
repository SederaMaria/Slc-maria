FactoryBot.define do
  factory :lease_application_underwriting_review do
    lease_application factory: :lease_application
    admin_user factory: :admin_user
    workflow_status factory: :workflow_status

    comments { FFaker::Lorem }
  end
end

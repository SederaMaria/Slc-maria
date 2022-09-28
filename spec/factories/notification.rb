FactoryBot.define do
  factory :notification do
    recipient { create(:dealer) }
    notifiable { create(:lease_application) }
    notification_content { 'application_submitted' }
    notification_mode { 'InApp' }

    trait :in_app do
      notification_mode { 'InApp' }
    end

    trait :email do
      notification_mode { 'Email' }
      notification_content { 'credit_decision' }
    end

    trait :with_attachments do
      after(:create) do |n|
        n.notification_attachments << create(:notification_attachment)
      end
    end

    trait :lease_document_request do
      notification_content { 'lease_documents_requested' }
      data { { lease_document_request_id: create(:lease_document_request).id } }
    end
  end
end

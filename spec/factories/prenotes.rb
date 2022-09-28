# == Schema Information
#
# Table name: prenotes
#
#  id                        :bigint(8)        not null, primary key
#  response                  :string
#  lease_application_id      :bigint(8)
#  created_at                :datetime         not null
#  updated_at                :datetime         not null
#  usio_confirmation_number  :string
#  usio_status               :string
#  usio_message              :string
#  usio_transaction_response :jsonb            not null
#  prenote_message           :string
#  prenote_status            :string
#  email_notification_sent   :boolean          default(FALSE)
#
# Indexes
#
#  index_prenotes_on_lease_application_id  (lease_application_id)
#
# Foreign Keys
#
#  fk_rails_...  (lease_application_id => lease_applications.id)
#

FactoryBot.define do
  factory :prenote do
    status { "MyString" }
    result { "MyString" }
    response { "MyString" }
    lease_application { nil }
  end
end

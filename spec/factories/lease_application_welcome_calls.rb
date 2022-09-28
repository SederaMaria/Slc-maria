# == Schema Information
#
# Table name: lease_application_welcome_calls
#
#  id                                  :bigint(8)        not null, primary key
#  lease_application_id                :integer
#  welcome_call_result_id              :integer
#  welcome_call_type_id                :integer
#  welcome_call_status_id              :integer
#  welcome_call_representative_type_id :integer
#  admin_id                            :integer
#  due_date                            :datetime
#  notes                               :string
#  created_at                          :datetime         not null
#  updated_at                          :datetime         not null
#

FactoryBot.define do
  factory :lease_application_welcome_call do
    welcome_call_result_id { 1 }
    welcome_call_type_id { 1 }
    due_date { "2019-11-20 01:51:38" }
    lease_appliction_id { 1 }
  end
end

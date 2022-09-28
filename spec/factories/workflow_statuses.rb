# == Schema Information
#
# Table name: workflow_statuses
#
#  id          :bigint(8)        not null, primary key
#  description :string
#  active      :boolean
#  created_at  :datetime         not null
#  updated_at  :datetime         not null
#

FactoryBot.define do
  factory :workflow_status do
    description { "MyString" }
    active { true }
  end
end

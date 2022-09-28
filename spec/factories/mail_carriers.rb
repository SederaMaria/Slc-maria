# == Schema Information
#
# Table name: mail_carriers
#
#  id          :bigint(8)        not null, primary key
#  description :string
#  active      :boolean
#  created_at  :datetime         not null
#  updated_at  :datetime         not null
#  sort_index  :integer
#

FactoryBot.define do
  factory :mail_carrier do
    description { "MyString" }
    active { false }
  end
end

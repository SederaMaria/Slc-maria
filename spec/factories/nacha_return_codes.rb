# == Schema Information
#
# Table name: nacha_return_codes
#
#  id          :bigint(8)        not null, primary key
#  code        :string
#  description :string
#  created_at  :datetime         not null
#  updated_at  :datetime         not null
#

FactoryBot.define do
  factory :nacha_return_code do
    code { "MyString" }
    description { "MyString" }
  end
end

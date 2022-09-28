# == Schema Information
#
# Table name: usio_return_codes
#
#  id          :bigint(8)        not null, primary key
#  code        :string
#  description :string
#  created_at  :datetime         not null
#  updated_at  :datetime         not null
#

FactoryBot.define do
  factory :usio_return_code do
    code { "MyString" }
    description { "MyString" }
  end
end

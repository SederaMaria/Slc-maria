# == Schema Information
#
# Table name: remote_check_return_codes
#
#  id          :bigint(8)        not null, primary key
#  code        :string
#  description :text
#  created_at  :datetime         not null
#  updated_at  :datetime         not null
#
# Indexes
#
#  index_remote_check_return_codes_on_code  (code)
#

FactoryBot.define do
  factory :remote_check_return_code do
    code { "MyString" }
    description { "MyText" }
  end
end

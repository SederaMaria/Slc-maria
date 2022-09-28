# == Schema Information
#
# Table name: employment_statuses
#
#  id                      :bigint(8)        not null, primary key
#  employment_status_index :integer
#  definition              :string
#  created_at              :datetime         not null
#  updated_at              :datetime         not null
#

FactoryBot.define do
  factory :employment_status do
    employment_status_index { 1 }
    definition { "MyString" }
  end
end

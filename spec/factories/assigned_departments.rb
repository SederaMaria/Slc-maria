# == Schema Information
#
# Table name: departments
#
#  id          :bigint(8)        not null, primary key
#  active      :boolean          default(TRUE)
#  description :string
#  created_at  :datetime         not null
#  updated_at  :datetime         not null
#

FactoryBot.define do
  factory :department do
    
  end
end

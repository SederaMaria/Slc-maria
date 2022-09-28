# == Schema Information
#
# Table name: welcome_call_statuses
#
#  id          :bigint(8)        not null, primary key
#  active      :boolean          default(TRUE)
#  description :string
#  created_at  :datetime         not null
#  updated_at  :datetime         not null
#

FactoryBot.define do
  factory :welcome_call_status do
    
  end
end

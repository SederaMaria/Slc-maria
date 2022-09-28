# == Schema Information
#
# Table name: welcome_call_results
#
#  id          :bigint(8)        not null, primary key
#  active      :boolean          default(TRUE)
#  description :string
#  created_at  :datetime         not null
#  updated_at  :datetime         not null
#  sort_index  :integer
#

FactoryBot.define do
  factory :welcome_call_result do
    
  end
end

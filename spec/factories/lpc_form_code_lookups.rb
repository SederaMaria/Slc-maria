# == Schema Information
#
# Table name: lpc_form_code_lookups
#
#  id               :bigint(8)        not null, primary key
#  lpc_form_code_id :integer
#  lpc_description  :string
#  created_at       :datetime         not null
#  updated_at       :datetime         not null
#  us_state_id      :bigint(8)
#

FactoryBot.define do
  factory :lpc_form_code_lookup do
    state_id { 1 }
    lpc_form_code_id { 1 }
    lpc_description { "MyString" }
  end
end

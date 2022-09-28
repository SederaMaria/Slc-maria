# == Schema Information
#
# Table name: tax_jurisdiction_types
#
#  id         :bigint(8)        not null, primary key
#  name       :string
#  sort_order :integer
#  created_at :datetime         not null
#  updated_at :datetime         not null
#
FactoryBot.define do
  factory :tax_jurisdiction_type do
    name {
      [
        "Customer's County/Town",
        "Customer's ZIP Code",
        "Dealership's ZIP Code",
        "Dealership's County/Town",
        "Custom"
      ].sample
    }
    sort_order { Array(1..5).sample }
  end
end

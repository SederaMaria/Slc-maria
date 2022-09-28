# == Schema Information
#
# Table name: tax_record_types
#
#  id                 :bigint(8)        not null, primary key
#  vertex_record_type :integer
#  record_type_desc   :string(100)
#  created_at         :datetime         not null
#  updated_at         :datetime         not null
#

FactoryBot.define do
  factory :tax_record_type do
    vertex_record_type { 1 }
    record_type_desc { "MyString" }
  end
end

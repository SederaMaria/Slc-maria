# == Schema Information
#
# Table name: lease_application_credcos
#
#  id                   :bigint(8)        not null, primary key
#  lease_application_id :integer
#  credco_xml           :string
#  created_at           :datetime         not null
#  updated_at           :datetime         not null
#

FactoryBot.define do
  factory :lease_application_credco do
    lease_application_id { 1 }
    credco_xml { "MyString" }
  end
end

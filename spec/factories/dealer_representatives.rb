# == Schema Information
#
# Table name: dealer_representatives
#
#  id            :bigint(8)        not null, primary key
#  email         :string
#  dealership_id :bigint(8)
#  created_at    :datetime         not null
#  updated_at    :datetime         not null
#  first_name    :string
#  last_name     :string
#  admin_user_id :bigint(8)
#  is_active     :boolean          default(TRUE)
#
# Indexes
#
#  index_dealer_representatives_on_admin_user_id  (admin_user_id)
#  index_dealer_representatives_on_dealership_id  (dealership_id)
#
# Foreign Keys
#
#  fk_rails_...  (admin_user_id => admin_users.id)
#  fk_rails_...  (dealership_id => dealerships.id)
#

FactoryBot.define do
  factory :dealer_representative do
    first_name { "Paul" }
    last_name { "Hamster" }
    email { "MyString" }
  end
end

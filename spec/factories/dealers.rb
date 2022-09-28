# == Schema Information
#
# Table name: dealers
#
#  id                      :integer          not null, primary key
#  first_name              :string(255)
#  last_name               :string(255)
#  email                   :string           default(""), not null
#  encrypted_password      :string           default(""), not null
#  reset_password_token    :string
#  reset_password_sent_at  :datetime
#  remember_created_at     :datetime
#  sign_in_count           :integer          default(0), not null
#  current_sign_in_at      :datetime
#  last_sign_in_at         :datetime
#  current_sign_in_ip      :inet
#  last_sign_in_ip         :inet
#  created_at              :datetime         not null
#  updated_at              :datetime         not null
#  dealership_id           :integer
#  first_sign_in_at        :datetime
#  is_disabled             :boolean          default(FALSE), not null
#  notify_credit_decision  :boolean          default(TRUE)
#  notify_funding_decision :boolean          default(TRUE)
#  failed_attempts         :integer          default(0), not null
#  unlock_token            :string
#  locked_at               :datetime
#  auth_token              :string
#  auth_token_created_at   :datetime
#  password_changed_at     :datetime
#  unique_session_id       :string(20)
#
# Indexes
#
#  index_dealers_on_auth_token_and_auth_token_created_at  (auth_token,auth_token_created_at)
#  index_dealers_on_dealership_id                         (dealership_id)
#  index_dealers_on_email                                 (email) UNIQUE
#  index_dealers_on_password_changed_at                   (password_changed_at)
#  index_dealers_on_reset_password_token                  (reset_password_token) UNIQUE
#  index_dealers_on_unlock_token                          (unlock_token) UNIQUE
#

FactoryBot.define do
  factory :dealer do
    dealership
    
    email       {FFaker::Internet.email}
    password    { "password" }
    first_name  {FFaker::Name.first_name}
    last_name   {FFaker::Name.last_name}
  end
end

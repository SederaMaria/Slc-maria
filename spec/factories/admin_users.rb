# == Schema Information
#
# Table name: admin_users
#
#  id                     :integer          not null, primary key
#  first_name             :string(255)
#  last_name              :string(255)
#  email                  :string           default(""), not null
#  encrypted_password     :string           default(""), not null
#  reset_password_token   :string
#  reset_password_sent_at :datetime
#  remember_created_at    :datetime
#  sign_in_count          :integer          default(0), not null
#  current_sign_in_at     :datetime
#  last_sign_in_at        :datetime
#  current_sign_in_ip     :inet
#  last_sign_in_ip        :inet
#  created_at             :datetime         not null
#  updated_at             :datetime         not null
#  password_changed_at    :datetime
#  failed_attempts        :integer          default(0), not null
#  unlock_token           :string
#  locked_at              :datetime
#  is_active              :boolean          default(TRUE)
#  job_title              :string
#  security_role          :string
#  auth_token             :string
#  auth_token_created_at  :datetime
#  security_role_id       :bigint(8)
#  unique_session_id      :string(20)
#  last_request_at        :datetime
#
# Indexes
#
#  index_admin_users_on_auth_token_and_auth_token_created_at  (auth_token,auth_token_created_at)
#  index_admin_users_on_email                                 (email) UNIQUE
#  index_admin_users_on_password_changed_at                   (password_changed_at)
#  index_admin_users_on_reset_password_token                  (reset_password_token) UNIQUE
#  index_admin_users_on_security_role_id                      (security_role_id)
#
# Foreign Keys
#
#  fk_rails_...  (security_role_id => security_roles.id)
#

FactoryBot.define do
  factory :admin_user do
    email { FFaker::Internet.email }
    sequence(:password) { |n| "P@ssword#{n}" }
  end
end

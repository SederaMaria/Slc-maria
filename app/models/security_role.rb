# == Schema Information
#
# Table name: security_roles
#
#  id                             :bigint(8)        not null, primary key
#  description                    :string
#  active                         :boolean          default(TRUE)
#  created_at                     :datetime         not null
#  updated_at                     :datetime         not null
#  can_see_welcome_call_dashboard :boolean          default(FALSE)
#

class SecurityRole < ApplicationRecord
  has_many :admin_user_security_roles
  has_many :admin_users, through: :admin_user_security_roles
  has_many :permissions
end

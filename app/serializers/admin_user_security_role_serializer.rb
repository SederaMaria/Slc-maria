# == Schema Information
#
# Table name: admin_user_security_roles
#
#  id                             :bigint(8)        not null, primary key
#  admin_user_id                  :bigint
#  security_role_id               :bigint
#  created_by_admin_id            :bigint
#  updated_by_admin_id            :bigint
#  created_at                     :datetime         not null
#  updated_at                     :datetime         not null
#

class AdminUserSecurityRoleSerializer < ApplicationSerializer
  attributes :id, :admin_user_id
end

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

class SecurityRoleSerializer < ApplicationSerializer
  attributes :id, :description
end

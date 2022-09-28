# == Schema Information
#
# Table name: permissions
#
#  id                     :integer          not null, primary key
#  security_role_id       :bigint
#  resource_id            :bigint           not null
#  action_id              :bigint           not null
#  created_by_admin_id    :bigint
#  updated_by_admin_id    :bigint
#  created_at             :datetime         not null
#  updated_at             :datetime         not null

class Permission < ApplicationRecord
  belongs_to :security_role
  #belongs_to :resource
  #belongs_to :action
end

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
#  auth_token             :string
#  auth_token_created_at  :datetime
#  unique_session_id      :string(20)
#  last_request_at        :datetime
#
# Indexes
#
#  index_admin_users_on_auth_token_and_auth_token_created_at  (auth_token,auth_token_created_at)
#  index_admin_users_on_email                                 (email) UNIQUE
#  index_admin_users_on_password_changed_at                   (password_changed_at)
#  index_admin_users_on_reset_password_token                  (reset_password_token) UNIQUE
#
# Foreign Keys
#
#  fk_rails_...  (security_role_id => security_roles.id)
#

class AdminUserSerializer < ApplicationSerializer
    attributes :userPermissions, :id, :first_name, :last_name, :email, :is_active, :job_title, :security_role, 
                :last_sign_in_at, :dealerships, :is_locked, :last_sign_in_at, :created_at, :last_sign_in_at_formated,
                :created_at_formated, :option_value, :option_label, :security_roles
                
    has_many :dealerships, serializer: DealershipSerializer
    has_one :dealer_representative
    has_many :admin_user_security_roles
    has_many :security_roles, through: :admin_user_security_roles

    include UserPermissions

    def userPermissions
      get_user_permissions(object)
    end

    def last_sign_in_at_formated
        object&.last_sign_in_at&.strftime('%b %-d, %Y at %I:%M %p %Z')
    end

    def created_at_formated
        object&.created_at&.strftime('%b %-d, %Y at %I:%M %p %Z')
    end

    def is_locked
        object.access_locked?
    end

    def option_value
        object&.id
    end

    def option_label
        object&.full_name
    end

    def security_role
      object&.security_roles.all.map{|r| r.description}
    end
end

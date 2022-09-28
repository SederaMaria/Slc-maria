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

class AdminUser < ApplicationRecord
  serialize :pinned_tabs, Array
  include SimpleAudit::Model
  simple_audit
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :password_expirable, :password_archivable, :session_limitable,
         :recoverable, :rememberable, :trackable, :validatable, :lockable, :timeoutable

  validates :password, format: { 
    with: /(?=.*[a-z])(?=.*[A-Z])(?=.*[0-9])(?=.*[!@#$%^&*\(\)\`\~\-\_\=\+\,\.\/\<\>\?\;\:\'\"\]\[\{\}\|\\]).{8,}/, 
    message: "must include at least one lowercase letter, one uppercase letter, one number, and one special character",
    allow_blank: true
  }

  has_many :notifications, as: :recipient
  has_one :dealer_representative
  has_many :dealerships, through: :dealer_representative
  has_many :admin_user_security_roles
  has_many :security_roles, through: :admin_user_security_roles

  has_many :comments, as: :author, class_name: 'ActiveAdminComment'
  has_many :workflow_setting_values
  
  scope :active,     -> { where(is_active: true) }

  def broadcast_channel
    "admin_user:#{id}"
  end

  def active_for_authentication?
    super && is_active?
  end
  
  def retrieve_audits
    audits_with_parents = Audit.with_parents(id)
    audits_with_admin_users = audits.with_admin_users.includes(:audited, :user).limit(1000) + audits_with_parents.with_admin_users.includes(:audited, :user).limit(1000)
    audits_with_no_users = audits.with_no_users.includes(:audited).limit(1000) + audits_with_parents.with_no_users.includes(:audited).limit(1000)
    (audits_with_admin_users + audits_with_no_users).sort { |a, b| b.created_at <=> a.created_at }
  end

  def password_required?
    new_record? ? false : super   
  end

  def generate_auth_token
    token = Digest::SHA1.hexdigest("--#{ BCrypt::Engine.generate_salt }--")
    self.update_columns(auth_token: token, auth_token_created_at: Time.zone.now)
    token
  end

  def full_name
    "#{first_name} #{last_name}"
  end

  def invalidate_auth_token
    self.update_columns(auth_token: nil, auth_token_created_at: nil)
  end

  def is_administrator?
    result = false
    user_security_roles = self&.security_roles

    if user_security_roles
      result = user_security_roles.any?{|r| r['description'].downcase == 'administrator'}
    end

    return result
  end

  def self.get_active_admin_users
    where.not(first_name: [nil, ""], last_name: [nil, ""], is_active: false).order(created_at: :desc).map{|x| [x.full_name, x.id]}
  end

end

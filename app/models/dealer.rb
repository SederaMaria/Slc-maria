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

class Dealer < ApplicationRecord
  include SimpleAudit::Model
  simple_audit
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :recoverable, :rememberable, :trackable, :validatable, :lockable, 
  :timeoutable, :password_expirable, :password_archivable, :session_limitable
  attr_accessor :skip_password_validation

  belongs_to :dealership
  
  has_many :lease_applications
  has_many :notifications, as: :recipient

  has_many :lessees,
    through: :lease_applications
  
  has_many :colessees,
    through: :lease_applications

  has_many :lease_calculators,
    through: :lease_applications

  # TODO Remove this once we migrate off ActiveAdmin
  default_scope -> { includes(:dealership).limit(1000) }
  delegate :name, to: :dealership, prefix: true, allow_nil: true

  validates :first_name, :last_name, :dealership_id, presence: true
  
  after_update :toggle_is_disable, if: :saved_change_to_locked_at?
  
  scope :active, -> {where(is_disabled: false)}
  scope :by_dealer_representative, ->(id) { where(dealership_id: [ DealerRepresentative.joins("JOIN dealer_representatives_dealerships AS drd ON dealer_representatives.id = drd.dealer_representative_id JOIN dealerships AS ds ON drd.dealership_id = ds.id JOIN dealers AS d ON ds.id = d.dealership_id  WHERE dealer_representatives.id IN(#{id})").select('ds.id').pluck('ds.id').uniq ]) }
  scope :logged_in, -> { where.not(auth_token: nil) }

  def full_name
    "#{first_name} #{last_name}"
  end
  
  def display_name
    "#{last_name}, #{first_name} (#{dealership_name} (ID #{dealership.id}))"
  end
  # select lessees.* from lessees
  #  INNER JOIN lease_applications
  #     ON "lessees"."id" = "lease_applications"."lessee_id"
  #     OR "lessees"."id" = "lease_applications"."colessee_id"
  #   WHERE "lease_applications"."dealer_id" = 2
  has_many :lessees_and_colessees, 
    ->(dealer) { 
      unscope(:where).
      joins(<<-SQL
        INNER JOIN lease_applications
          ON "lessees"."id" = "lease_applications"."lessee_id"
          OR "lessees"."id" = "lease_applications"."colessee_id"
        SQL
      ).
      where("\"lease_applications\".\"dealer_id\" = :dealer_id", dealer_id: dealer.id) },
    class_name: 'Lessee'
  
  def broadcast_channel
    "dealer:#{id}"
  end

  def after_database_authentication
    return unless sign_in_count.zero?
    update first_sign_in_at: Time.now
  end

  def active_for_authentication?
    super && !is_disabled?
  end

  def password_required?
    return false if skip_password_validation
    super
  end
  

  def self.ransackable_scopes(_auth_object = nil)
    %i[by_dealer_representative]
  end 

  def toggle_is_disable
    self.update_column(:is_disabled, self.access_locked?)
  end

  def generate_auth_token
    token = Digest::SHA1.hexdigest("--#{ BCrypt::Engine.generate_salt }--")
    self.update_columns(auth_token: token, auth_token_created_at: Time.zone.now)
    token
  end

  def invalidate_auth_token
    self.update_columns(auth_token: nil, auth_token_created_at: nil)
  end

  def retrieve_audits
    self.audits.limit(1000)
  end
  
end

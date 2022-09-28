# == Schema Information
#
# Table name: stipulations
#
#  id                            :integer          not null, primary key
#  description                   :string
#  abbreviation                  :string
#  created_at                    :datetime         not null
#  updated_at                    :datetime         not null
#  required                      :boolean          default(FALSE)
#  position                      :integer
#  separator                     :string           default("-")
#  pre_income_stipulation        :boolean          default(FALSE)
#  post_income_stipulation       :boolean          default(FALSE)
#  post_submission_stipulation   :boolean          default(FALSE)
#  blocks_credit_status_approved :boolean          default(FALSE), not null
#  verification_call_problem     :boolean          default(FALSE)
#

class Stipulation < ApplicationRecord
  
  PROOF_OF_INCOME  = 'POI'.freeze
  FOUR_REFERENCES  = '4Refs'.freeze
  PROOF_SOCIAL_SEC = 'POSS'.freeze
  PROOF_RESIDENCE  = 'POR'.freeze
  MISCELLANEOUS    = 'MISC'.freeze
  DEFAULT_DESCRIPTION = 'Default Description'.freeze

  validates :description, :abbreviation, presence: true

  scope :with_abbreviation, ->(abbreviation) { where(abbreviation: abbreviation) }

  scope :sorted_position, -> { order('position asc, id desc') }

  has_many :lease_application_stipulations
  has_many :lease_applications,
    through: :lease_application_stipulations
  
  has_many :stipulation_credit_tiers , dependent: :destroy
  has_many :stipulation_credit_tier_types, through: :stipulation_credit_tiers
  scope :required, -> { where(required: true) }
  scope :post_submission_required, -> { where(post_submission_stipulation: true) }
  scope :blocks_credit_status_approved, -> { where(blocks_credit_status_approved: true) }
  scope :verification_call_problem, -> { where(verification_call_problem: true) }
  scope :active, -> { where(active: true) }

  def display_name
    description
  end

  def self.[](abbreviation)
    self.with_abbreviation(abbreviation).first_or_create(description: DEFAULT_DESCRIPTION)
  end

  def self.proof_of_income
    self[PROOF_OF_INCOME]
  end

  def self.requires_four_references
    self[FOUR_REFERENCES]
  end

  def self.proof_of_social_security_number
    self[PROOF_SOCIAL_SEC]
  end

  def self.proof_of_residence
    self[PROOF_RESIDENCE]
  end

  def self.miscellaneous
    self[MISCELLANEOUS]
  end

end

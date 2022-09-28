# == Schema Information
#
# Table name: makes
#
#  id              :integer          not null, primary key
#  name            :string
#  vin_starts_with :string
#  created_at      :datetime         not null
#  updated_at      :datetime         not null
#  lms_manf        :string(10)
#  nada_enabled    :boolean          default(FALSE)
#  active          :boolean          default(TRUE)
#

class Make < ApplicationRecord
  HARLEY_DAVIDSON = 'Harley-Davidson'.freeze

  has_many :credit_tiers
  has_many :model_groups, dependent: :destroy
  has_many :model_years, through: :model_groups
  has_one :application_setting

  validates :name, presence: true
  validates :lms_manf, presence: true
  scope :active,     -> { where(active: true) }
  def self.[](make)
    self.where(arel_table[:name].matches("%#{make}%")).first_or_create
  end

  def self.harley_davidson
    self[HARLEY_DAVIDSON]
  end

  def credit_tier_ids
    credit_tiers.ids
  end
end

# == Schema Information
#
# Table name: model_years
#
#  id                           :integer          not null, primary key
#  original_msrp_cents          :integer          default(0), not null
#  nada_avg_retail_cents        :integer          default(0), not null
#  nada_rough_cents             :integer          default(0), not null
#  name                         :string
#  year                         :integer
#  residual_24_cents            :integer          default(0), not null
#  residual_36_cents            :integer          default(0), not null
#  residual_48_cents            :integer          default(0), not null
#  created_at                   :datetime         not null
#  updated_at                   :datetime         not null
#  model_group_id               :integer
#  residual_60_cents            :integer          default(0), not null
#  maximum_haircut_0            :decimal(4, 2)    default(1.0), not null
#  maximum_haircut_1            :decimal(4, 2)    default(1.0), not null
#  maximum_haircut_2            :decimal(4, 2)    default(1.0), not null
#  maximum_haircut_3            :decimal(4, 2)    default(1.0), not null
#  maximum_haircut_4            :decimal(4, 2)    default(1.0), not null
#  maximum_haircut_5            :decimal(4, 2)    default(1.0), not null
#  maximum_haircut_6            :decimal(4, 2)    default(1.0), not null
#  maximum_haircut_7            :decimal(4, 2)    default(1.0), not null
#  maximum_haircut_8            :decimal(4, 2)    default(1.0), not null
#  maximum_haircut_9            :decimal(4, 2)    default(1.0), not null
#  maximum_haircut_10           :decimal(4, 2)    default(1.0), not null
#  maximum_haircut_11           :decimal(4, 2)    default(1.0), not null
#  maximum_haircut_12           :decimal(4, 2)    default(1.0), not null
#  maximum_haircut_13           :decimal(4, 2)    default(1.0), not null
#  maximum_haircut_14           :decimal(4, 2)    default(1.0), not null
#  start_date                   :date             default(Wed, 01 May 2019)
#  end_date                     :date             default(Tue, 31 Dec 2999)
#  nada_model_number            :string
#  police_bike                  :boolean          default(FALSE), not null
#  nada_volume_number           :string
#  slc_model_group_mapping_flag :boolean          default(TRUE)
#  nada_model_group_name        :string
#
# Indexes
#
#  index_model_years_on_model_group_id  (model_group_id)
#

class ModelYear < ApplicationRecord
  belongs_to :model_group
  has_one :make,
    through: :model_group

  validates :start_date, presence: true
  validates :end_date, presence: true

  after_update :mark_slc_model_group_mapping_flag

  #monetize all _cents fields with a couple of lines
  if table_exists?
    self.column_names.each { |col| monetize(col) if col.ends_with?('_cents') }
  end

  delegate :minimum_dealer_participation, :residual_reduction_percentage, to: :model_group

  scope :for_make_name, ->(make_name) { joins(:make).merge(Make.where(name: make_name))}
  scope :for_make_model_and_year, ->(asset_make, asset_model, asset_year) {
    for_make_name(asset_make).for_year(asset_year).where(name: asset_model)
  }
  scope :for_year, ->(year) { where(year: year) }
  # scope :active, -> { where(end_date: '2999-12-31', slc_model_group_mapping_flag: true) }
  scope :active, -> { where( slc_model_group_mapping_flag: true).where(" ? >= date(start_date) AND ? <= date(end_date)", Date.today, Date.today) }
  scope :inactive, -> { where(end_date: '2999-12-31') }
  scope :active_nada_rough, -> { where.not(nada_rough_cents: 0) }

  scope :between_start_end, ->(date) { where( slc_model_group_mapping_flag: true).where(" ? >= date(start_date) AND ? <= date(end_date)", date, date) }

  def mark_slc_model_group_mapping_flag
    update_column(:slc_model_group_mapping_flag, true) if model_group_id_changed?
  end
end

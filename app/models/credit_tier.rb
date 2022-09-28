# == Schema Information
#
# Table name: credit_tiers
#
#  id                               :integer          not null, primary key
#  position                         :integer
#  make_id                          :integer
#  description                      :string
#  irr_value                        :decimal(8, 2)    default(0.0)
#  created_at                       :datetime         not null
#  updated_at                       :datetime         not null
#  maximum_fi_advance_percentage    :decimal(4, 2)    default(0.0)
#  maximum_advance_percentage       :decimal(5, 2)    default(0.0)
#  required_down_payment_percentage :decimal(4, 2)    default(0.0)
#  security_deposit                 :integer          default(0), not null
#  enable_security_deposit          :boolean          default(FALSE)
#  acquisition_fee_cents            :integer          default(99500)
#  effective_date                   :date
#  end_date                         :date
#  payment_limit_percentage         :decimal(4, 2)    default(0.0)
#  model_group_id                   :bigint(8)
#
# Indexes
#
#  index_credit_tiers_on_make_id         (make_id)
#  index_credit_tiers_on_model_group_id  (model_group_id)
#
# Foreign Keys
#
#  fk_rails_...  (model_group_id => model_groups.id)
#

class CreditTier < ApplicationRecord
  belongs_to :make
  belongs_to :model_group
  has_many :adjusted_capitalized_cost_ranges
  acts_as_list scope: :make_id
  
  validates :effective_date, presence: true
  validates :model_group, presence: true
  validates :end_date, presence: true
  validates :payment_limit_percentage, numericality: { greater_than_or_equal_to: 0, less_than_or_equal_to: 99, message: "Range should be between 0 to 99."}

  scope :for_make_name, ->(make_name) { joins(:make).merge(Make.where(name: make_name))}
  
  #monetize all _cents fields with a couple of lines
  if table_exists? #fix issue with rake db:schema:load
    self.column_names.each { |col| monetize(col) if col.ends_with?('_cents') }
  end
  
  def tier_level
    description&.split(' ')[1].to_i
  end
end

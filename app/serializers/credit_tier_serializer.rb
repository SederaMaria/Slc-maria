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

class CreditTierSerializer < ApplicationSerializer
    attributes :id, :description, :make_id, :payment_limit_percentage
end

# == Schema Information
#
# Table name: model_groups
#
#  id                                 :integer          not null, primary key
#  name                               :string
#  created_at                         :datetime         not null
#  updated_at                         :datetime         not null
#  make_id                            :integer
#  minimum_dealer_participation_cents :integer          default(0), not null
#  residual_reduction_percentage      :decimal(, )      default(0.0), not null
#  maximum_term_length                :integer          default(60), not null
#  backend_advance_minimum_cents      :integer          default(0), not null
#  maximum_haircut_0                  :decimal(4, 2)    default(1.0), not null
#  maximum_haircut_1                  :decimal(4, 2)    default(1.0), not null
#  maximum_haircut_2                  :decimal(4, 2)    default(1.0), not null
#  maximum_haircut_3                  :decimal(4, 2)    default(1.0), not null
#  maximum_haircut_4                  :decimal(4, 2)    default(1.0), not null
#  maximum_haircut_5                  :decimal(4, 2)    default(1.0), not null
#  maximum_haircut_6                  :decimal(4, 2)    default(1.0), not null
#  maximum_haircut_7                  :decimal(4, 2)    default(1.0), not null
#  maximum_haircut_8                  :decimal(4, 2)    default(1.0), not null
#  maximum_haircut_9                  :decimal(4, 2)    default(1.0), not null
#  maximum_haircut_10                 :decimal(4, 2)    default(1.0), not null
#  maximum_haircut_11                 :decimal(4, 2)    default(1.0), not null
#  maximum_haircut_12                 :decimal(4, 2)    default(1.0), not null
#  maximum_haircut_13                 :decimal(4, 2)    default(1.0), not null
#  maximum_haircut_14                 :decimal(4, 2)    default(1.0), not null
#  sort_index                         :integer
#
# Indexes
#
#  index_model_groups_on_make_id  (make_id)
#
# Foreign Keys
#
#  fk_rails_...  (make_id => makes.id)
#

FactoryBot.define do
  factory :model_group do
    make
    name                          { FFaker::Product.model }
    minimum_dealer_participation  { Random.new.rand(100..200).to_money }
    backend_advance_minimum       { Random.new.rand(100..200).to_money }
    residual_reduction_percentage { Random.new.rand(0.0..100.0).round(2) }
    maximum_term_length           { LeaseCalculator::TERMS.max }
  end
end

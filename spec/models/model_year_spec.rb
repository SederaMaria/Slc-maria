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

require 'rails_helper'

RSpec.describe ModelYear, type: :model do
  pending "add some examples to (or delete) #{__FILE__}"
end

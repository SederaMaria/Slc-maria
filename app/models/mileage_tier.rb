# == Schema Information
#
# Table name: mileage_tiers
#
#  id                                  :integer          not null, primary key
#  upper                               :integer
#  lower                               :integer
#  created_at                          :datetime         not null
#  updated_at                          :datetime         not null
#  maximum_frontend_advance_haircut_0  :decimal(4, 2)    default(0.0), not null
#  maximum_frontend_advance_haircut_1  :decimal(4, 2)    default(0.0), not null
#  maximum_frontend_advance_haircut_2  :decimal(4, 2)    default(0.0), not null
#  maximum_frontend_advance_haircut_3  :decimal(4, 2)    default(0.0), not null
#  maximum_frontend_advance_haircut_4  :decimal(4, 2)    default(0.0), not null
#  maximum_frontend_advance_haircut_5  :decimal(4, 2)    default(0.0), not null
#  maximum_frontend_advance_haircut_6  :decimal(4, 2)    default(0.0), not null
#  maximum_frontend_advance_haircut_7  :decimal(4, 2)    default(0.0), not null
#  maximum_frontend_advance_haircut_8  :decimal(4, 2)    default(0.0), not null
#  maximum_frontend_advance_haircut_9  :decimal(4, 2)    default(0.0), not null
#  custom_label                        :string
#  position                            :integer
#  maximum_frontend_advance_haircut_10 :decimal(4, 2)    default(0.0), not null
#  maximum_frontend_advance_haircut_11 :decimal(4, 2)    default(0.0), not null
#  maximum_frontend_advance_haircut_12 :decimal(4, 2)    default(0.0), not null
#  maximum_frontend_advance_haircut_13 :decimal(4, 2)    default(0.0), not null
#  maximum_frontend_advance_haircut_14 :decimal(4, 2)    default(0.0), not null
#

class MileageTier < ApplicationRecord
  acts_as_list

  def display_name
    custom_label.blank? ? "#{lower} - #{upper}" : custom_label
  end
end

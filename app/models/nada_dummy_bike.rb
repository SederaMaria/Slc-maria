# == Schema Information
#
# Table name: nada_dummy_bikes
#
#  id               :bigint(8)        not null, primary key
#  year             :string
#  model_group_name :string
#  bike_model_name  :string
#  nada_rough_cents :string
#  created_at       :datetime         not null
#  updated_at       :datetime         not null
#  make_id          :integer
#

class NadaDummyBike < ApplicationRecord
	belongs_to :make
end

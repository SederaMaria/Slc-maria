# == Schema Information
#
# Table name: slc_model_groups
#
#  id                   :bigint(8)        not null, primary key
#  model_year           :integer
#  model                :string
#  slc_model_group_name :string
#  created_at           :datetime         not null
#  updated_at           :datetime         not null
#  make_id              :bigint(8)
#
# Indexes
#
#  index_slc_model_groups_on_make_id  (make_id)
#
# Foreign Keys
#
#  fk_rails_...  (make_id => makes.id)
#

class SlcModelGroup < ApplicationRecord
  belongs_to :make
end

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

class MakeSerializer < ApplicationSerializer
  attributes :id, :name, :active
end

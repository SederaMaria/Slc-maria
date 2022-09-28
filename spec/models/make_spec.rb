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

require 'rails_helper'

RSpec.describe Make, type: :model do
  pending "add some examples to (or delete) #{__FILE__}"
end

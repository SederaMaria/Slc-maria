# == Schema Information
#
# Table name: usio_return_codes
#
#  id          :bigint(8)        not null, primary key
#  code        :string
#  description :string
#  created_at  :datetime         not null
#  updated_at  :datetime         not null
#

require 'rails_helper'

RSpec.describe UsioReturnCode, type: :model do
  pending "add some examples to (or delete) #{__FILE__}"
end

# == Schema Information
#
# Table name: remote_check_return_codes
#
#  id          :bigint(8)        not null, primary key
#  code        :string
#  description :text
#  created_at  :datetime         not null
#  updated_at  :datetime         not null
#
# Indexes
#
#  index_remote_check_return_codes_on_code  (code)
#

require 'rails_helper'

RSpec.describe RemoteCheckReturnCode, type: :model do
  pending "add some examples to (or delete) #{__FILE__}"
end

# == Schema Information
#
# Table name: nacha_noc_codes
#
#  id          :bigint(8)        not null, primary key
#  code        :string
#  description :text
#  created_at  :datetime         not null
#  updated_at  :datetime         not null
#
# Indexes
#
#  index_nacha_noc_codes_on_code  (code)
#

class NachaNocCode < ApplicationRecord
end

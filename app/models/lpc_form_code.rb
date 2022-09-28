# == Schema Information
#
# Table name: lpc_form_codes
#
#  id                   :bigint(8)        not null, primary key
#  lpc_form_code_id     :integer
#  lpc_form_code_abbrev :string
#  created_at           :datetime         not null
#  updated_at           :datetime         not null
#

class LpcFormCode < ApplicationRecord
end

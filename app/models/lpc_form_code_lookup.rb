# == Schema Information
#
# Table name: lpc_form_code_lookups
#
#  id               :bigint(8)        not null, primary key
#  lpc_form_code_id :integer
#  lpc_description  :string
#  created_at       :datetime         not null
#  updated_at       :datetime         not null
#  us_state_id      :bigint(8)
#

class LpcFormCodeLookup < ApplicationRecord
  belongs_to :lpc_form_code, foreign_key: "lpc_form_code_id", :primary_key => 'lpc_form_code_id'
  #belongs_to :state
  belongs_to :us_state
end

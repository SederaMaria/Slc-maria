# == Schema Information
#
# Table name: us_states
#
#  id                         :bigint(8)        not null, primary key
#  name                       :string
#  abbreviation               :string
#  sum_of_payments_state      :boolean
#  active_on_calculator       :boolean
#  created_at                 :datetime         not null
#  updated_at                 :datetime         not null
#  security_deposit           :integer          default(0), not null
#  enable_security_deposit    :boolean          default(FALSE)
#  label_text                 :string
#  hyperlink                  :string
#  state_enum                 :integer
#  geo_code_state             :string(2)
#  tax_jurisdiction_type_id   :bigint(8)
#  secretary_of_state_website :string
#
# Indexes
#
#  index_us_states_on_abbreviation              (abbreviation) UNIQUE
#  index_us_states_on_state_enum                (state_enum) UNIQUE
#  index_us_states_on_tax_jurisdiction_type_id  (tax_jurisdiction_type_id)
#

require 'rails_helper'

RSpec.describe UsState, type: :model do
  pending "add some examples to (or delete) #{__FILE__}"
end

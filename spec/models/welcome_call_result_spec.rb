# == Schema Information
#
# Table name: welcome_call_results
#
#  id          :bigint(8)        not null, primary key
#  active      :boolean          default(TRUE)
#  description :string
#  created_at  :datetime         not null
#  updated_at  :datetime         not null
#  sort_index  :integer
#

require 'rails_helper'

RSpec.describe WelcomeCallResult, type: :model do
  pending "add some examples to (or delete) #{__FILE__}"
end

# == Schema Information
#
# Table name: welcome_call_statuses
#
#  id          :bigint(8)        not null, primary key
#  active      :boolean          default(TRUE)
#  description :string
#  created_at  :datetime         not null
#  updated_at  :datetime         not null
#

require 'rails_helper'

RSpec.describe WelcomeCallStatus, type: :model do
  pending "add some examples to (or delete) #{__FILE__}"
end

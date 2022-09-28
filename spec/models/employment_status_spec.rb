# == Schema Information
#
# Table name: employment_statuses
#
#  id                      :bigint(8)        not null, primary key
#  employment_status_index :integer
#  definition              :string
#  created_at              :datetime         not null
#  updated_at              :datetime         not null
#

require 'rails_helper'

RSpec.describe EmploymentStatus, type: :model do
  pending "add some examples to (or delete) #{__FILE__}"
end

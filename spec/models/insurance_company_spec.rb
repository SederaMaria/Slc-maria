# == Schema Information
#
# Table name: insurance_companies
#
#  id           :bigint(8)        not null, primary key
#  company_name :string
#  company_code :string
#  created_at   :datetime         not null
#  updated_at   :datetime         not null
#

require 'rails_helper'

RSpec.describe InsuranceCompany, type: :model do
  pending "add some examples to (or delete) #{__FILE__}"
end
